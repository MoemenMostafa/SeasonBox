import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/app/providers/user_profile_provider.dart';
import 'package:seasonbox/data/services/subscription_service.dart';
import 'package:seasonbox/widgets/app_card.dart';
import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:seasonbox/data/services/posthog_service.dart';
import 'package:seasonbox/data/services/remote_config_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  Map<String, String>? _pricing;
  bool _isLoading = true;
  bool _isYearly = true; // Default to yearly for best value
  SubscriptionService? _subscriptionService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscriptionService ??= context.read<SubscriptionService>();
  }

  @override
  void dispose() {
    _subscriptionService?.removeListener(_handleSubscriptionUpdate);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchPricing();
    _trackScreenView();
    // Listen for verification errors from the service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context
            .read<SubscriptionService>()
            .addListener(_handleSubscriptionUpdate);
      }
    });
  }

  void _handleSubscriptionUpdate() {
    if (!mounted) return;
    final service = context.read<SubscriptionService>();
    final userProvider = context.read<UserProfileProvider>();

    // If user just became premium, show celebration!
    if (userProvider.isPremium) {
      context.go('/premium-congratulations');
      return;
    }

    if (service.verificationError != null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              l10n.subscription_restore_failed(service.verificationError!)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _trackScreenView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = GoRouterState.of(context);
      final source = state.uri.queryParameters['source'] ?? 'unknown';

      PostHogService().screen('SubscriptionScreen', properties: {
        'source': source,
      });
      PostHogService.log('subscription_screen_viewed', context: {
        'source': source,
      });
    });
  }

  void _trackPlanSelected(String tier, String price) {
    final state = GoRouterState.of(context);
    final source = state.uri.queryParameters['source'] ?? 'unknown';

    PostHogService().captureEvent('subscription_plan_selected', properties: {
      'plan_tier': tier,
      'billing_period': _isYearly ? 'yearly' : 'monthly',
      'price': price,
      'source': source,
    });
  }

  void _fetchPricing() {
    final subscriptionService = context.read<SubscriptionService>();
    final pricing = subscriptionService.getPricing();
    if (mounted) {
      setState(() {
        _pricing = pricing;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProfileProvider>();
    final isPaid = userProvider.isPremium;

    final l10n = AppLocalizations.of(context)!;
    final subscriptionService = context.watch<SubscriptionService>();
    final productIds =
        context.read<RemoteConfigService>().getSubscriptionProductIds();
    final basePlanIds =
        context.read<RemoteConfigService>().getSubscriptionBasePlanIds();

    final monthlyPrice = subscriptionService.getBasePlanPrice(
          productIds['monthly']!,
          basePlanIds['monthly']!,
        ) ??
        _pricing?['monthly'] ??
        '4.99';
    final yearlyPrice = subscriptionService.getBasePlanPrice(
          productIds['yearly']!,
          basePlanIds['yearly']!,
        ) ??
        _pricing?['yearly'] ??
        '49.99';
    final currentPrice = _isYearly ? yearlyPrice : monthlyPrice;
    final periodSuffix = _isYearly ? '/yr' : '/mo';

    return Scaffold(
      appBar: SeasonBoxAppBar(
        title: l10n.subscription_title,
        subtitle: l10n.subscription_subtitle,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (!subscriptionService.isAvailable)
                    _buildStoreErrorBanner(subscriptionService, l10n, context),

                  // Billing Cycle Toggle
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildToggleButton(
                            label: l10n.subscription_billing_monthly,
                            isSelected: !_isYearly,
                            onTap: () => setState(() => _isYearly = false),
                          ),
                          _buildToggleButton(
                            label: l10n.subscription_billing_yearly,
                            isSelected: _isYearly,
                            onTap: () => setState(() => _isYearly = true),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTierCard(
                    title: l10n.subscription_tier_freeTitle,
                    price: l10n.subscription_tier_freePrice,
                    description: l10n.subscription_tier_freeDesc,
                    features: [
                      l10n.subscription_feature_items_free,
                      l10n.subscription_feature_photos_free,
                      l10n.subscription_feature_members_free,
                      l10n.subscription_feature_storage_free,
                    ],
                    isCurrent: !isPaid,
                    color: Colors.grey.shade400,
                    onUpgrade: () {
                      _trackPlanSelected(
                          'free', l10n.subscription_tier_freePrice);
                      // Already on free tier or switching back?
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTierCard(
                    title: l10n.subscription_tier_premiumTitle,
                    price: l10n.subscription_tier_premiumPrice(
                        currentPrice, periodSuffix),
                    description: l10n.subscription_tier_premiumDesc,
                    features: [
                      l10n.subscription_feature_items_premium,
                      l10n.subscription_feature_photos_premium,
                      l10n.subscription_feature_members_premium,
                      l10n.subscription_feature_sharing_premium,
                      l10n.subscription_feature_growth_premium,
                      l10n.subscription_feature_reminders_premium,
                    ],
                    isCurrent: isPaid,
                    color: Colors.purple,
                    isBestValue: _isYearly,
                    savingsLabel:
                        _isYearly ? l10n.subscription_savingsLabel('16') : null,
                    onUpgrade: () async {
                      _trackPlanSelected('premium', currentPrice);

                      final subscriptionService =
                          context.read<SubscriptionService>();
                      final remoteConfig = context.read<RemoteConfigService>();
                      final productIds =
                          remoteConfig.getSubscriptionProductIds();
                      final basePlanIds =
                          remoteConfig.getSubscriptionBasePlanIds();

                      final targetProductId = _isYearly
                          ? productIds['yearly']
                          : productIds['monthly'];
                      final targetBasePlanId = _isYearly
                          ? basePlanIds['yearly']
                          : basePlanIds['monthly'];

                      if (kIsWeb) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'In-app purchases are not yet supported on the web version. Please use our mobile app.')),
                        );
                        return;
                      }

                      ProductDetails? product;
                      try {
                        product = subscriptionService.products.firstWhere(
                          (p) => p.id == targetProductId,
                        );
                      } catch (e) {
                        // Product not found in store
                      }

                      if (product == null) {
                        if (!context.mounted) return;
                        final isAvailable = subscriptionService.isAvailable;
                        final productsCount =
                            subscriptionService.products.length;
                        final loadedIds = subscriptionService.products
                            .map((p) => p.id)
                            .toList();

                        PostHogService().captureEvent(
                            'subscription_screen_unavailable',
                            properties: {
                              'store_available': isAvailable,
                              'products_count': productsCount,
                              'target_id': targetProductId ?? 'unknown',
                              'loaded_ids': loadedIds,
                              'debug_mode': kDebugMode,
                              'last_error':
                                  subscriptionService.lastError ?? 'none',
                            });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isAvailable
                                ? l10n.subscription_error_product_not_found(
                                    targetProductId ?? 'unknown')
                                : '${l10n.subscription_error_store_unavailable}\nDiagnostics: Store: Error, Products: $productsCount, Target: $targetProductId, Loaded: $loadedIds, Debug: $kDebugMode, Last Error: ${subscriptionService.lastError ?? "none"}'),
                            backgroundColor: Colors.red.shade800,
                            duration: const Duration(seconds: 10),
                            action: SnackBarAction(
                              label: l10n.subscription_button_retry_connection,
                              textColor: Colors.white,
                              onPressed: () =>
                                  subscriptionService.reInitialize(),
                            ),
                          ),
                        );
                        return;
                      }

                      try {
                        await subscriptionService.buySubscription(
                          product,
                          basePlanId: targetBasePlanId,
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Payment failed: $e')),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.subscription_cancelAnytime,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      await context
                          .read<SubscriptionService>()
                          .restorePurchases();
                      if (!context.mounted) return;
                      final error =
                          context.read<SubscriptionService>().verificationError;
                      if (!context.mounted) return;
                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text(l10n.subscription_restore_failed(error)),
                              backgroundColor: Colors.red),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(l10n.subscription_restore_success),
                              backgroundColor: Colors.green),
                        );
                      }
                    },
                    child: Text(l10n.subscription_restore_btn),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.purple : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildTierCard({
    required String title,
    required String price,
    required String description,
    required List<String> features,
    required bool isCurrent,
    required Color color,
    bool isBestValue = false,
    String? savingsLabel,
    VoidCallback? onUpgrade,
  }) {
    return AppCard(
      backgroundColor: isCurrent ? color.withValues(alpha: 0.05) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (savingsLabel != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    savingsLabel,
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              if (isBestValue)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.subscription_bestValue,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const Divider(height: 32),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: color, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(f)),
                  ],
                ),
              )),
          const SizedBox(height: 24),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                AppLocalizations.of(context)!.subscription_currentPlan,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          else
            ElevatedButton(
              onPressed: onUpgrade,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: isBestValue ? 4 : 0,
              ),
              child: Text(
                AppLocalizations.of(context)!.subscription_selectPlan,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStoreErrorBanner(SubscriptionService subscriptionService,
      AppLocalizations l10n, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.subscription_error_store_unavailable,
                  style: TextStyle(
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (subscriptionService.lastError != null) ...[
            const SizedBox(height: 8),
            Text(
              subscriptionService.lastError!,
              style: TextStyle(
                color: Colors.red.shade800,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => subscriptionService.reInitialize(),
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(l10n.subscription_button_retry_connection),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
