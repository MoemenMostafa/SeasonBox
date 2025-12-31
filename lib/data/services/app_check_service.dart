import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'posthog_service.dart';

class AppCheckService {
  final FirebaseAppCheck _appCheck;

  AppCheckService({FirebaseAppCheck? appCheck})
      : _appCheck = appCheck ?? FirebaseAppCheck.instance;

  Future<void> initialize() async {
    // Skip App Check on Web platform
    if (kIsWeb) {
      PostHogService.log('Skipping Firebase App Check on Web platform',
          level: LogLevel.info);
      return;
    }

    try {
      // For Android, we use Play Integrity.
      // For web, we can use reCAPTCHA v3 or Enterprise.
      // For iOS/macOS, we use Device Check or App Attest.

      await _appCheck.activate(
        // Default provider for Android is Play Integrity
        androidProvider:
            kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
        // For web, we can use reCAPTCHA Enterprise
        webProvider: ReCaptchaEnterpriseProvider(
            '6Lc5zV8qAAAAAEm5zV8qAAAAAEm5zV8qAAAAAEm5zV8q'),
        // For Apple platforms, use DeviceCheck or AppAttest
        appleProvider: AppleProvider.deviceCheck,
      );

      PostHogService.log('Firebase App Check initialized',
          level: LogLevel.info);

      // If in debug mode, print the debug token
      if (kDebugMode) {
        final token = await _appCheck.getToken();
        PostHogService.log('App Check debug token: $token',
            level: LogLevel.debug);
      }
    } catch (e) {
      PostHogService().logError('app_check_init_error', e);
    }
  }

  Future<String?> getToken() async {
    try {
      return await _appCheck.getToken();
    } catch (e) {
      PostHogService().logError('app_check_token_error', e);
      return null;
    }
  }
}
