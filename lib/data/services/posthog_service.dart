import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

/// Available log levels for the application.
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// Service for PostHog analytics, session replay, and comprehensive logging.
/// Handles user identification, event tracking, and debug logging for live sessions.
class PostHogService {
  static final PostHogService _instance = PostHogService._internal();
  factory PostHogService() => _instance;
  PostHogService._internal();

  static const String _apiKey =
      'phc_U0I4o4YSC2QCcOKDp7TCjYpxmixIZc16vLSSwGEQ7m';
  static const String _host = 'https://eu.i.posthog.com';

  bool _initialized = false;

  /// Initialize PostHog with configuration
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final config = PostHogConfig(_apiKey);
      config.host = _host;
      config.captureApplicationLifecycleEvents = true;
      config.debug = kDebugMode;
      config.sessionReplay = true;
      config.sessionReplayConfig.maskAllTexts = false;
      config.sessionReplayConfig.maskAllImages = false;
      config.sessionReplayConfig.throttleDelay =
          const Duration(milliseconds: 1000);

      await Posthog().setup(config);
      _initialized = true;

      // Log initialization
      await log('PostHog initialized successfully', level: LogLevel.info);
    } catch (e) {
      // Use print here since PostHog failed
      // ignore: avoid_print
      print('❌ Error initializing PostHog: $e');
    }
  }

  /// Global log method (can be called via PostHogService.log)
  static Future<void> log(
    String message, {
    LogLevel level = LogLevel.debug,
    Map<String, dynamic>? context,
  }) async {
    await _instance._logInternal(level, message, context: context);
  }

  Future<void> _logInternal(
    LogLevel level,
    String message, {
    Map<String, dynamic>? context,
  }) async {
    if (!_initialized) return;

    final levelStr = level.name;

    try {
      await Posthog().capture(
        eventName: 'app_log_$levelStr',
        properties: {
          'level': levelStr,
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
          if (context != null)
            ...context.map((k, v) => MapEntry(k, v.toString())),
        },
      );

      if (kDebugMode) {
        final emoji = {
              LogLevel.debug: '🔍',
              LogLevel.info: 'ℹ️',
              LogLevel.warning: '⚠️',
              LogLevel.error: '❌',
            }[level] ??
            '📝';
        // ignore: avoid_print
        print('$emoji [$levelStr] $message');
      }
    } catch (e) {
      // ignore: avoid_print
      if (kDebugMode) print('Error sending log to PostHog: $e');
    }
  }

  /// Legacy method for backward compatibility if needed, redirects to log
  Future<void> logToPostHog(
    LogLevel level,
    String message, {
    Map<String, dynamic>? context,
    bool mirrorToConsole = true,
  }) async {
    await _logInternal(level, message, context: context);
  }

  /// Specialized log for errors
  void logError(String errorName, dynamic error,
      {StackTrace? stackTrace, Map<String, dynamic>? context}) {
    log('ERROR: $errorName - $error', level: LogLevel.error, context: {
      if (stackTrace != null) 'stack_trace': stackTrace.toString(),
      if (context != null) ...context,
    });
  }

  /// Log Flutter framework errors
  void logFlutterError(FlutterErrorDetails details) {
    log('FLUTTER ERROR: ${details.exception}', level: LogLevel.error, context: {
      'error_type': details.exception.runtimeType.toString(),
      'stack_trace': details.stack?.toString() ?? 'No stack trace',
      'library': details.library ?? 'unknown',
      'context': details.context?.toString() ?? 'No context',
      'is_fatal': !details.silent,
    });
  }

  /// Capture a custom event
  Future<void> captureEvent(String eventName,
      {Map<String, Object>? properties}) async {
    if (!_initialized) return;
    try {
      await Posthog().capture(eventName: eventName, properties: properties);
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('Error capturing event $eventName: $e');
      }
    }
  }

  /// Track screen view
  Future<void> screen(String screenName,
      {Map<String, Object>? properties}) async {
    if (!_initialized) return;
    try {
      await Posthog().screen(screenName: screenName, properties: properties);
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('Error tracking screen $screenName: $e');
      }
    }
  }

  /// Identify a user
  Future<void> identify(
      {required String userId, Map<String, Object>? userProperties}) async {
    if (!_initialized) return;
    try {
      await Posthog().identify(userId: userId, userProperties: userProperties);
    } catch (e) {
      logError('posthog_identify_failed', e);
    }
  }

  /// Reset PostHog (call on logout)
  Future<void> reset() async {
    if (!_initialized) return;
    try {
      await captureEvent('user_logged_out');
      await Posthog().reset();
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('Error resetting PostHog: $e');
      }
    }
  }

  /// Send a test event to verify PostHog is working
  Future<void> sendTestEvent() async {
    await captureEvent('posthog_test_event', properties: {
      'timestamp': DateTime.now().toIso8601String(),
      'test_message': 'PostHog is working!',
      'platform': 'flutter',
    });
  }
}
