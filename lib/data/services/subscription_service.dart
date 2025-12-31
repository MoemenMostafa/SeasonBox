import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import '../models/app_user.dart';
import '../models/family.dart';
import 'remote_config_service.dart';
import 'posthog_service.dart';

class SubscriptionService extends ChangeNotifier {
  static const int freeTierItemLimit = 50;
  static const int freeTierMemberLimit = 4;

  final RemoteConfigService _remoteConfigService;
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _available = false;
  String? _lastError;

  List<ProductDetails> get products => _products;

  /// Whether the IAP store is available on this device.
  bool get isAvailable => _available;

  /// The last error encountered during initialization.
  String? get lastError => _lastError;

  SubscriptionService(this._remoteConfigService) {
    if (kIsWeb) {
      PostHogService.log('SubscriptionService: Skipping constructor on web',
          level: LogLevel.info);
      return;
    }
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        PostHogService().logError('subscription_stream_error', error);
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> initialize() async {
    if (kIsWeb) {
      PostHogService.log('SubscriptionService: Skipping initialization on web',
          level: LogLevel.info);
      _available = false;
      return;
    }
    try {
      debugPrint('SubscriptionService: [PLATFORM] $defaultTargetPlatform');
      debugPrint('SubscriptionService: [DEBUG_MODE] $kDebugMode');
      _lastError = null;

      // Retry logic for initial connection
      int retryCount = 0;
      const int maxRetries = 2;

      while (retryCount <= maxRetries) {
        debugPrint(
            'SubscriptionService: Checking availability (attempt ${retryCount + 1})...');
        _available = await _iap.isAvailable();

        if (_available) break;

        if (retryCount < maxRetries) {
          debugPrint(
              'SubscriptionService: Not available, retrying in 2 seconds...');
          await Future.delayed(const Duration(seconds: 2));
        }
        retryCount++;
      }

      PostHogService()
          .captureEvent('subscription_store_available', properties: {
        'available': _available,
        'platform': defaultTargetPlatform.toString(),
        'debug_mode': kDebugMode,
        'attempts': retryCount,
      });

      if (!_available) {
        _lastError = 'Store not available after $retryCount attempts';
        PostHogService()
            .logError('subscription_store_unavailable', _lastError!, context: {
          'platform': defaultTargetPlatform.toString(),
          'debug_mode': kDebugMode,
        });
      } else {
        await loadProducts();
      }
    } catch (e) {
      _lastError = e.toString();
      PostHogService().logError('subscription_init_failed', e, context: {
        'platform': defaultTargetPlatform.toString(),
        'debug_mode': kDebugMode,
      });
    }
    notifyListeners();
  }

  /// Manually retry store initialization.
  Future<void> reInitialize() async {
    PostHogService.log(
        'SubscriptionService: Manual re-initialization triggered',
        level: LogLevel.info);
    await initialize();
  }

  Future<void> loadProducts() async {
    final productIds = _remoteConfigService.getSubscriptionProductIds();
    final Set<String> kIds = productIds.values.toSet();
    debugPrint('SubscriptionService: Querying products for IDs: $kIds');

    await PostHogService().trackLatency('load_subscription_products', () async {
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(kIds);

      if (response.notFoundIDs.isNotEmpty) {
        PostHogService.log(
            'SubscriptionService: Products NOT found in store: ${response.notFoundIDs}',
            level: LogLevel.warning);
        PostHogService()
            .captureEvent('subscription_products_missing', properties: {
          'missing_ids': response.notFoundIDs,
        });
      }

      if (response.error != null) {
        PostHogService.log(
            'SubscriptionService: Query error: ${response.error?.message}',
            level: LogLevel.error);
      }

      _products = response.productDetails;
      debugPrint(
          'SubscriptionService: response.productDetails.length = ${_products.length}');

      PostHogService()
          .captureEvent('subscription_products_loaded', properties: {
        'count': _products.length,
        'product_ids': _products.map((p) => p.id).toList(),
      });
    }, context: {'query_ids': kIds.toList()});

    notifyListeners();
  }

  Future<void> buySubscription(ProductDetails product,
      {String? basePlanId}) async {
    PostHogService().captureEvent('subscription_purchase_start', properties: {
      'product_id': product.id,
      'base_plan_id': basePlanId ?? 'none',
    });

    late PurchaseParam purchaseParam;

    if (product is GooglePlayProductDetails && basePlanId != null) {
      final dynamic googleProduct = product;
      final offers = googleProduct.subscriptionOfferDetails;
      if (offers != null && offers.isNotEmpty) {
        purchaseParam = GooglePlayPurchaseParam(
          productDetails: product,
          applicationUserName: null,
          changeSubscriptionParam: null,
        );
      } else {
        purchaseParam = PurchaseParam(productDetails: product);
      }
    } else {
      purchaseParam = PurchaseParam(productDetails: product);
    }

    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Gets the price for a specific base plan from the product details.
  String? getBasePlanPrice(String productId, String basePlanId) {
    final product = _products.cast<ProductDetails?>().firstWhere(
          (p) => p?.id == productId,
          orElse: () => null,
        );

    if (product is GooglePlayProductDetails) {
      final dynamic googleProduct = product;
      final offers = googleProduct.subscriptionOfferDetails;
      if (offers != null && offers.isNotEmpty) {
        final offer = offers.firstWhere(
          (o) => o.basePlanId == basePlanId,
          orElse: () => offers.first,
        );
        return offer.pricingPhases.first.formattedPrice;
      }
    }

    return product?.price;
  }

  Future<void> _onPurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      PostHogService()
          .captureEvent('subscription_purchase_update', properties: {
        'status': purchaseDetails.status.name,
        'product_id': purchaseDetails.productID,
        'purchase_id': purchaseDetails.purchaseID ?? 'none',
        'error': purchaseDetails.error?.toString() ?? 'none',
      });

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
    return await PostHogService().trackLatency('verify_subscription_purchase',
        () async {
      try {
        final callable =
            FirebaseFunctions.instance.httpsCallable('verifyPurchase');
        final result = await callable.call({
          'subscriptionId': purchaseDetails.productID,
          'purchaseToken':
              purchaseDetails.verificationData.serverVerificationData,
        });

        final success = result.data['success'] == true;
        PostHogService()
            .captureEvent('subscription_verification_result', properties: {
          'success': success,
          'product_id': purchaseDetails.productID,
        });

        return success;
      } catch (e) {
        PostHogService()
            .logError('subscription_verification_failed', e, context: {
          'product_id': purchaseDetails.productID,
        });
        return false;
      }
    }, context: {'product_id': purchaseDetails.productID});
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
