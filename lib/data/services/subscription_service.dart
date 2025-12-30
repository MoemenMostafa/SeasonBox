import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/app_user.dart';
import '../models/family.dart';
import 'remote_config_service.dart';

class SubscriptionService extends ChangeNotifier {
  static const int freeTierItemLimit = 50;
  static const int freeTierMemberLimit = 4;

  final RemoteConfigService _remoteConfigService;
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> _products = [];
  bool _available = false;

  SubscriptionService(this._remoteConfigService) {
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => debugPrint('Purchase stream error: $error'),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  /// Initialized the IAP service and loads products.
  Future<void> initialize() async {
    _available = await _iap.isAvailable();
    if (_available) {
      await loadProducts();
    }
  }

  Future<void> loadProducts() async {
    final productIds = _remoteConfigService.getSubscriptionProductIds();
    final Set<String> kIds = productIds.values.toSet();
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(kIds);
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }
    _products = response.productDetails;
    notifyListeners();
  }

  List<ProductDetails> get products => _products;

  Future<void> buySubscription(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> _onPurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI if needed
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint('Purchase error: ${purchaseDetails.error}');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            // Success!
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable('verifyPurchase');
      final result = await callable.call({
        'uid': purchaseDetails.verificationData
            .localVerificationData, // This is just a placeholder, in reality we get UID from auth
        'subscriptionId': purchaseDetails.productID,
        'purchaseToken':
            purchaseDetails.verificationData.serverVerificationData,
      });
      return result.data['success'] == true;
    } catch (e) {
      debugPrint('Verification error: $e');
      return false;
    }
  }

  /// Checks if a user is within their item limit.
  bool canAddItem(AppUser user, Family family) {
    if (isPremium(user)) return true;
    return family.itemCount < freeTierItemLimit;
  }

  /// Checks if a user can add more members.
  bool canAddMember(AppUser user, int currentMemberCount) {
    if (isPremium(user)) return true;
    return currentMemberCount < freeTierMemberLimit;
  }

  /// Gets the photo limit per item based on user tier.
  int getPhotoLimit(AppUser user) {
    return isPremium(user) ? 3 : 1;
  }

  /// Checks if a user is Premium.
  bool isPremium(AppUser user) {
    return user.subscriptionTier == 'paid';
  }

  /// Gets the dynamic price for the paid tier from Remote Config.
  Map<String, String> getPricing() {
    return _remoteConfigService.getSubscriptionPricing();
  }

  /// Checks if a feature is available for the user.
  bool isFeatureAvailable(String featureId, AppUser user) {
    switch (featureId) {
      case 'family_sharing':
      case 'growth_advice':
      case 'seasonal_reminders':
        return isPremium(user);
      default:
        return true;
    }
  }
}
