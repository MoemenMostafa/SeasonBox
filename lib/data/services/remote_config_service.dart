import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:convert';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService(this._remoteConfig);

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 10),
    ));

    // Set defaults
    await _remoteConfig.setDefaults({
      'subscription_pricing': jsonEncode({
        'monthly': '2.99',
        'yearly': '19.99',
      }),
      'subscription_product_ids': jsonEncode({
        'monthly': 'premium',
        'yearly': 'premium',
      }),
      'subscription_base_plan_ids': jsonEncode({
        'monthly': 'monthly',
        'yearly': 'yearly',
      }),
      'enable_demo_mode': true,
    });

    await _remoteConfig.fetchAndActivate();
  }

  Map<String, String> getSubscriptionPricing() {
    final jsonString = _remoteConfig.getString('subscription_pricing');
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return {
        'monthly': data['monthly']?.toString() ?? '2.99',
        'yearly': data['yearly']?.toString() ?? '19.99',
      };
    } catch (e) {
      return {
        'monthly': '2.99',
        'yearly': '19.99',
      };
    }
  }

  Map<String, String> getSubscriptionProductIds() {
    final jsonString = _remoteConfig.getString('subscription_product_ids');
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return {
        'monthly': data['monthly']?.toString() ?? 'premium',
        'yearly': data['yearly']?.toString() ?? 'premium',
      };
    } catch (e) {
      return {
        'monthly': 'premium',
        'yearly': 'premium',
      };
    }
  }

  Map<String, String> getSubscriptionBasePlanIds() {
    final jsonString = _remoteConfig.getString('subscription_base_plan_ids');
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return {
        'monthly': data['monthly']?.toString() ?? 'monthly',
        'yearly': data['yearly']?.toString() ?? 'yearly',
      };
    } catch (e) {
      return {
        'monthly': 'monthly',
        'yearly': 'yearly',
      };
    }
  }

  bool isDemoModeEnabled() {
    return _remoteConfig.getBool('enable_demo_mode');
  }
}
