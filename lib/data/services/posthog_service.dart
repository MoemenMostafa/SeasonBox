import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

/// Service for PostHog analytics, session replay, and comprehensive logging.
/// Handles user identification, event tracking, and debug logging for live sessions.
class PostHogService {
  static const String _apiKey =
      'phc_U0I4o4YSC2QCcOKDp7TCjYpxmixIZc16vLSSwGEQ7m';
  static const String _host = 'https://eu.i.posthog.com';

  bool _initialized = false;

  /// Initialize PostHog with configuration
  Future<void> initialize() async {
    if (_initialized) {
      debugPrint('PostHog already initialized');
      return;
    }

    try {
      final config = PostHogConfig(_apiKey);
      config.host = _host;
      config.captureApplicationLifecycleEvents = true;
      // Debug console logging only in debug mode
      // In release, logs will be sent to PostHog as events instead
      config.debug = kDebugMode;

      // Enable session replay for ALL builds (debug and release)
      config.sessionReplay = true;

      // Configure session replay settings
      config.sessionReplayConfig.maskAllTexts =
          false; // Set to true to mask sensitive text
      config.sessionReplayConfig.maskAllImages =
          false; // Set to true to mask images
      config.sessionReplayConfig.throttleDelay =
          const Duration(milliseconds: 1000);

      await Posthog().setup(config);

      _initialized = true;
      debugPrint('✅ PostHog initialized successfully');
      debugPrint('📊 PostHog Host: $_host');
      debugPrint('📊 PostHog API Key: ${_apiKey.substring(0, 10)}...');

      // Log initialization event
      await captureEvent('posthog_initialized');

      // Send a test event to verify connectivity
      await sendTestEvent();

      // Log that we're in production mode
      if (!kDebugMode) {
        await captureEvent('app_running_in_production', properties: {
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      debugPrint('❌ Error initializing PostHog: $e');
      logError('posthog_initialization_failed', e);
    }
  }

  /// Log Flutter framework errors
  void logFlutterError(FlutterErrorDetails details) {
    final properties = <String, Object>{
      'error': details.exception.toString(),
      'error_type': details.exception.runtimeType.toString(),
      'stack_trace': details.stack?.toString() ?? 'No stack trace',
      'library': details.library ?? 'unknown',
      'context': details.context?.toString() ?? 'No context',
      'timestamp': DateTime.now().toIso8601String(),
      'is_fatal': !details.silent,
    };

    captureEvent('flutter_error', properties: properties);

    // In debug mode, also print to console
    if (kDebugMode) {
      debugPrint('🔴 FLUTTER ERROR: ${details.exception}');
    }
  }

  /// Custom log method that sends logs to PostHog (visible in dashboard)
  /// In debug mode: prints to console AND sends to PostHog
  /// In release mode: ONLY sends to PostHog (no console output)
  Future<void> logToPostHog(
    String level, // 'debug', 'info', 'warning', 'error'
    String message, {
    Map<String, dynamic>? context,
  }) async {
    // Always send to PostHog
    await captureEvent('app_log_$level', properties: {
      'level': level,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      if (context != null) ...context.map((k, v) => MapEntry(k, v.toString())),
    });

    // Only print to console in debug mode
    if (kDebugMode) {
      final emoji = {
            'debug': '🔍',
            'info': 'ℹ️',
            'warning': '⚠️',
            'error': '❌',
          }[level] ??
          '📝';
      debugPrint('$emoji [$level] $message');
    }
  }

  /// Identify a user with PostHog
  Future<void> identify({
    required String userId,
    Map<String, Object>? userProperties,
  }) async {
    if (!_initialized) {
      debugPrint('PostHog not initialized, skipping identify');
      return;
    }

    try {
      await Posthog().identify(
        userId: userId,
        userProperties: userProperties,
      );
      debugPrint('User identified: $userId');
    } catch (e) {
      debugPrint('Error identifying user: $e');
      logError('posthog_identify_failed', e);
    }
  }

  /// Send a test event to verify PostHog is working
  Future<void> sendTestEvent() async {
    debugPrint('📊 Sending test event to PostHog...');
    await captureEvent('posthog_test_event', properties: {
      'timestamp': DateTime.now().toIso8601String(),
      'test_message': 'PostHog is working!',
      'platform': 'flutter',
    });
    debugPrint('📊 Test event sent! Check PostHog dashboard.');
  }

  /// Capture a custom event
  Future<void> captureEvent(
    String eventName, {
    Map<String, Object>? properties,
  }) async {
    if (!_initialized) {
      debugPrint('⚠️ PostHog not initialized, skipping event: $eventName');
      return;
    }

    try {
      await Posthog().capture(
        eventName: eventName,
        properties: properties,
      );
      debugPrint(
          '✅ Event captured: $eventName ${properties != null ? "with ${properties.length} properties" : ""}');
    } catch (e) {
      debugPrint('❌ Error capturing event $eventName: $e');
    }
  }

  /// Track screen view
  Future<void> screen(
    String screenName, {
    Map<String, Object>? properties,
  }) async {
    if (!_initialized) {
      debugPrint('PostHog not initialized, skipping screen: $screenName');
      return;
    }

    try {
      await Posthog().screen(
        screenName: screenName,
        properties: properties,
      );
      debugPrint('Screen tracked: $screenName');
    } catch (e) {
      debugPrint('Error tracking screen $screenName: $e');
    }
  }

  /// Set user properties
  Future<void> setUserProperties(Map<String, Object> properties) async {
    if (!_initialized) {
      debugPrint('PostHog not initialized, skipping user properties');
      return;
    }

    try {
      // Use identify to update user properties
      final userId = await Posthog().getDistinctId();
      await Posthog().identify(
        userId: userId,
        userProperties: properties,
      );
      debugPrint('User properties set: $properties');
    } catch (e) {
      debugPrint('Error setting user properties: $e');
      logError('posthog_set_properties_failed', e);
    }
  }

  /// Reset PostHog (call on logout)
  Future<void> reset() async {
    if (!_initialized) {
      debugPrint('PostHog not initialized, skipping reset');
      return;
    }

    try {
      await captureEvent('user_logged_out');
      await Posthog().reset();
      debugPrint('PostHog reset');
    } catch (e) {
      debugPrint('Error resetting PostHog: $e');
    }
  }

  // ============================================================================
  // COMPREHENSIVE LOGGING FOR DEBUGGING LIVE SESSIONS
  // ============================================================================

  /// Log an error with context
  Future<void> logError(
    String errorName,
    dynamic error, {
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) async {
    final properties = <String, Object>{
      'error': error.toString(),
      'error_type': error.runtimeType.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      if (stackTrace != null) 'stack_trace': stackTrace.toString(),
      if (context != null) ...context.map((k, v) => MapEntry(k, v.toString())),
    };

    await captureEvent('error_$errorName', properties: properties);
    debugPrint('❌ ERROR: $errorName - $error');
  }

  /// Log a warning
  Future<void> logWarning(
    String warningName,
    String message, {
    Map<String, dynamic>? context,
  }) async {
    final properties = <String, Object>{
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      if (context != null) ...context.map((k, v) => MapEntry(k, v.toString())),
    };

    await captureEvent('warning_$warningName', properties: properties);
    debugPrint('⚠️ WARNING: $warningName - $message');
  }

  /// Log network call
  Future<void> logNetworkCall({
    required String method,
    required String endpoint,
    int? statusCode,
    dynamic requestBody,
    dynamic responseBody,
    String? error,
    Duration? duration,
  }) async {
    final properties = <String, Object>{
      'method': method,
      'endpoint': endpoint,
      'timestamp': DateTime.now().toIso8601String(),
      if (statusCode != null) 'status_code': statusCode,
      if (requestBody != null) 'request_body': requestBody.toString(),
      if (responseBody != null) 'response_body': responseBody.toString(),
      if (error != null) 'error': error,
      if (duration != null) 'duration_ms': duration.inMilliseconds,
    };

    final eventName = error != null ? 'network_call_failed' : 'network_call';
    await captureEvent(eventName, properties: properties);

    if (error != null) {
      debugPrint('🌐 NETWORK ERROR: $method $endpoint - $error');
    } else {
      debugPrint('🌐 NETWORK: $method $endpoint - $statusCode');
    }
  }

  /// Log permission request/result
  Future<void> logPermission({
    required String permissionType,
    required String
        status, // 'granted', 'denied', 'restricted', 'permanentlyDenied'
    Map<String, dynamic>? context,
  }) async {
    final properties = <String, Object>{
      'permission_type': permissionType,
      'status': status,
      'timestamp': DateTime.now().toIso8601String(),
      if (context != null) ...context.map((k, v) => MapEntry(k, v.toString())),
    };

    await captureEvent('permission_$status', properties: properties);
    debugPrint('🔐 PERMISSION: $permissionType - $status');
  }

  /// Log Firestore operation
  Future<void> logFirestoreOperation({
    required String operation, // 'read', 'write', 'update', 'delete'
    required String collection,
    String? documentId,
    bool success = true,
    String? error,
    Map<String, dynamic>? data,
  }) async {
    final properties = <String, Object>{
      'operation': operation,
      'collection': collection,
      'success': success,
      'timestamp': DateTime.now().toIso8601String(),
      if (documentId != null) 'document_id': documentId,
      if (error != null) 'error': error,
      if (data != null) 'data': data.toString(),
    };

    final eventName = success
        ? 'firestore_${operation}_success'
        : 'firestore_${operation}_failed';
    await captureEvent(eventName, properties: properties);

    if (!success) {
      debugPrint('🔥 FIRESTORE ERROR: $operation on $collection - $error');
    }
  }

  /// Log authentication event
  Future<void> logAuth({
    required String action, // 'login', 'register', 'logout', 'login_failed'
    String? method, // 'email', 'google', 'biometric'
    String? error,
    Map<String, dynamic>? context,
  }) async {
    final properties = <String, Object>{
      'action': action,
      'timestamp': DateTime.now().toIso8601String(),
      if (method != null) 'method': method,
      if (error != null) 'error': error,
      if (context != null) ...context.map((k, v) => MapEntry(k, v.toString())),
    };

    await captureEvent('auth_$action', properties: properties);
    debugPrint('🔑 AUTH: $action ${method != null ? "($method)" : ""}');
  }

  /// Log user action
  Future<void> logUserAction({
    required String action,
    String? target,
    Map<String, dynamic>? context,
  }) async {
    final properties = <String, Object>{
      'action': action,
      'timestamp': DateTime.now().toIso8601String(),
      if (target != null) 'target': target,
      if (context != null) ...context.map((k, v) => MapEntry(k, v.toString())),
    };

    await captureEvent('user_action_$action', properties: properties);
    debugPrint('👤 USER ACTION: $action ${target != null ? "- $target" : ""}');
  }

  /// Log app lifecycle event
  Future<void> logAppLifecycle(String event) async {
    await captureEvent('app_lifecycle_$event', properties: {
      'timestamp': DateTime.now().toIso8601String(),
    });
    debugPrint('📱 APP LIFECYCLE: $event');
  }

  /// Log performance metric
  Future<void> logPerformance({
    required String metric,
    required num value,
    String? unit,
    Map<String, dynamic>? context,
  }) async {
    final properties = <String, Object>{
      'metric': metric,
      'value': value,
      'timestamp': DateTime.now().toIso8601String(),
      if (unit != null) 'unit': unit,
      if (context != null) ...context.map((k, v) => MapEntry(k, v.toString())),
    };

    await captureEvent('performance_$metric', properties: properties);
    debugPrint(
        '⚡ PERFORMANCE: $metric = $value${unit != null ? " $unit" : ""}');
  }
}
