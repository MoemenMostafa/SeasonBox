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

  bool isDemoModeEnabled() {
    return _remoteConfig.getBool('enable_demo_mode');
  }
}
