# PostHog Analytics Integration

## Overview

SeasonBox uses [PostHog](https://posthog.com) for analytics, session replay, and comprehensive debug logging. This document explains the integration architecture, how to use it, and best practices.

## Configuration

### Credentials

- **API Key**: `phc_U0I4o4YSC2QCcOKDp7TCjYpxmixIZc16vLSSwGEQ7m`
- **Host**: `https://eu.i.posthog.com` (EU Cloud)
- **Dashboard**: https://eu.i.posthog.com

### Platform Configuration

#### Flutter (Dart)

Configuration is in [`lib/data/services/posthog_service.dart`](file:///Users/m.mostafa/Workspace/code/SeasonBox/lib/data/services/posthog_service.dart):

```dart
static const String _apiKey = 'phc_U0I4o4YSC2QCcOKDp7TCjYpxmixIZc16vLSSwGEQ7m';
static const String _host = 'https://eu.i.posthog.com';
```

#### Android

Configuration is in [`android/app/src/main/AndroidManifest.xml`](file:///Users/m.mostafa/Workspace/code/SeasonBox/android/app/src/main/AndroidManifest.xml):

```xml
<meta-data android:name="com.posthog.posthog.API_KEY" android:value="phc_U0I4o4YSC2QCcOKDp7TCjYpxmixIZc16vLSSwGEQ7m" />
<meta-data android:name="com.posthog.posthog.POSTHOG_HOST" android:value="https://eu.i.posthog.com" />
<meta-data android:name="com.posthog.posthog.TRACK_APPLICATION_LIFECYCLE_EVENTS" android:value="true" />
<meta-data android:name="com.posthog.posthog.DEBUG" android:value="true" />
```

## Architecture

### Service Layer

The `PostHogService` class provides a centralized interface for all analytics and logging:

**Location**: [`lib/data/services/posthog_service.dart`](file:///Users/m.mostafa/Workspace/code/SeasonBox/lib/data/services/posthog_service.dart)

**Initialization**: Happens in [`lib/main.dart`](file:///Users/m.mostafa/Workspace/code/SeasonBox/lib/main.dart) before app startup:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  final postHogService = PostHogService();
  await postHogService.initialize();
  
  runApp(SeasonBox(postHogService: postHogService));
}
```

**Dependency Injection**: Available app-wide via Provider:

```dart
Provider<PostHogService>.value(value: postHogService)
```

### Features

#### 1. Core Analytics
- User identification (`PostHogService().identify`)
- Event tracking (`PostHogService.log`)
- Deep Link Tracking (Captured in `GoRouter` via `deeplink_opened` event)
#### Automatic Screen Tracking (GoRouter)

Automatic screen tracking is enabled by adding the `PosthogObserver` to the router configuration in [`lib/app/routes/router.dart`](file:///Users/m.mostafa/Workspace/code/SeasonBox/lib/app/routes/router.dart):

```dart
static final GoRouter router = GoRouter(
  observers: [PosthogObserver()],
  // ... routes
);
```

And ensuring the `MaterialApp` is wrapped with `PostHogWidget` in [`lib/main.dart`](file:///Users/m.mostafa/Workspace/code/SeasonBox/lib/main.dart):

```dart
return PostHogWidget(
  child: MaterialApp.router(...),
);
```

#### Manual Screen Tracking
- User identification (`PostHogService().identify`)
- Event tracking (`PostHogService.log`)
- User properties
- Session management

#### 2. Session Replay
- Automatic session recording
- Visual playback of interactions

#### 3. Standardized Service Logging
Comprehensive logging via dedicated service wrappers:
- **`FirestoreService`**: Intercepts all database operations.
- **`StorageService`**: Tracks file uploads, deletions, and transformations.
- **`AuthService`**: Logs sign-in/out lifecycle and user identification.
- **`BiometricService`**: Records authentication results and status changes.
- **`UserService`**: Tracks Cloud Function execution and user management.

#### 4. Performance & Latency Tracking
- **`trackLatency`**: Generic helper to measure and report execution time of any async operation.
- **Automatic Metrics**: Pre-configured in Storage and Firestore layers.

#### 5. UI Flow Abandonment (Drop Detection)
- Tracks when users start filling forms (AddItem, AddMember) but leave without saving.

## Usage Guide

### Accessing PostHogService

In any widget or service:

```dart
import 'package:provider/provider.dart';
import 'package:seasonbox/data/services/posthog_service.dart';

// In a widget
final postHog = Provider.of<PostHogService>(context, listen: false);

// Or using context.read
final postHog = context.read<PostHogService>();
```

### Common Patterns

#### User Identification

Identify users after successful authentication:

```dart
await postHog.identify(
  userId: user.uid,
  userProperties: {
    'email': user.email ?? '',
    'display_name': user.displayName ?? '',
    'family_id': familyId,
    'role': userRole,
    'created_at': user.metadata.creationTime?.toIso8601String() ?? '',
  },
);
```

#### Authentication Events

```dart
// Successful login
await postHog.logAuth(
  action: 'login',
  method: 'email', // or 'google', 'biometric'
);

// Failed login
await postHog.logAuth(
  action: 'login_failed',
  method: 'email',
  error: e.toString(),
);

// Registration
await postHog.logAuth(
  action: 'register',
  method: 'email',
  context: {'has_family_code': familyCode != null},
);

// Logout (also resets PostHog session)
await postHog.reset();
```

#### Error Logging

```dart
try {
  // Critical operation
  await someOperation();
} catch (e, stackTrace) {
  await postHog.logError(
    'operation_name_failed',
    e,
    stackTrace: stackTrace,
    context: {
      'user_id': userId,
      'family_id': familyId,
      'additional_context': 'any relevant data',
    },
  );
  rethrow; // or handle appropriately
}
```

#### Firestore Operations (Standardized)

**DEPRECATED**: Do not log Firestore operations manually in repositories.

**RECOMMENDED**: Use `FirestoreService` wrapper methods. They handle logging and error reporting automatically.

```dart
// Use this in Repositories
await _firestoreService.updateDocument(
  docRef: _firestoreService.items(item.familyId).doc(item.id),
  data: item.toMap(),
);
```

Internal implementation in `FirestoreService`:
```dart
Future<void> updateDocument({
  required DocumentReference docRef,
  required Map<String, dynamic> data,
}) async {
  try {
    await PostHogService.log('Firestore UPDATE: ${docRef.path}',
        level: LogLevel.info, context: {'path': docRef.path});
    await docRef.update(data);
  } catch (e) {
    PostHogService().logError('firestore_update_failed', e, context: {'path': docRef.path});
    rethrow;
  }
}
```

#### Permission Tracking

```dart
// Camera permission
final status = await Permission.camera.request();
await postHog.logPermission(
  permissionType: 'camera',
  status: status.isGranted ? 'granted' : 'denied',
);

// Biometric permission
await postHog.logPermission(
  permissionType: 'biometric',
  status: canAuthenticate ? 'granted' : 'denied',
  context: {'device_supports_biometric': deviceSupports},
);
```

#### User Actions

Track important user interactions:

```dart
// Item created
await postHog.logUserAction(
  action: 'item_created',
  target: itemName,
  context: {
    'category': category,
    'location_id': locationId,
    'has_image': hasImage,
  },
);

// Family joined
await postHog.logUserAction(
  action: 'family_joined',
  target: familyId,
  context: {'member_count': memberCount},
);

// Profile updated
await postHog.logUserAction(
  action: 'profile_updated',
  context: {'fields_changed': ['displayName', 'phoneNumber']},
);
```

#### Screen Tracking

```dart
// Manual screen tracking
await postHog.screen(
  'ItemDetailsScreen',
  properties: {
    'item_id': itemId,
    'category': category,
  },
);
```

#### Deep Link Tracking

When the app is opened via a deep link (App Link or Universal Link), an event is automatically captured in the router:

**Location**: [`lib/app/routes/router.dart`](file:///Users/m.mostafa/Workspace/code/SeasonBox/lib/app/routes/router.dart)

```dart
PostHogService().captureEvent('deeplink_opened', properties: {
  'route': '/items',
  'memberId': memberId,
  'locationId': locationId,
});
```


#### Performance & Latency Tracking

Use the `trackLatency` helper to automatically measure and log operation duration:

```dart
return await PostHogService().trackLatency('operation_name', () async {
  // Your async logic here
  return await someAsyncCall();
}, context: {'extra': 'data'});
```

This will capture:
- **Event Name**: `operation_name`
- **Property**: `latency_ms` (the duration)
- **Context**: Any additional properties passed.

#### UI Abandonment Tracking

Implement drop detection in forms using `PopScope` and an `_isDirty` flag:

```dart
// In a Stateful widget
bool _isDirty = false;

// Listen to controllers
_nameController.addListener(() => _isDirty = true);

// In build()
return PopScope(
  canPop: true,
  onPopInvokedWithResult: (bool didPop, dynamic result) {
    if (didPop && _isDirty && !_isSaving) {
      PostHogService.log('ui_abandonment', context: {'screen': 'MyScreen'});
    }
  },
  child: Scaffold(...),
);
```

#### Warnings

```dart
if (potentialIssue) {
  await postHog.logWarning(
    'data_inconsistency',
    'User has items but no storage locations',
    context: {
      'user_id': userId,
      'item_count': itemCount,
    },
  );
}
```

## API Reference

### Core Methods

| Method | Description | Parameters |
|--------|-------------|------------|
| `initialize()` | Initialize PostHog SDK | None |
| `identify()` | Identify a user | `userId`, `userProperties` |
| `captureEvent()` | Track a custom event | `eventName`, `properties` |
| `screen()` | Track screen view | `screenName`, `properties` |
| `setUserProperties()` | Update user properties | `properties` |
| `reset()` | Reset session (on logout) | None |

| Method | Description | Use Case |
|--------|-------------|----------|
| `log()` | Log a general event | Successful operations, user navigation |
| `logError()` | Log errors with stack traces | Production error tracking |
| `logWarning()` | Log warnings | Potential logic inconsistencies |
| `trackLatency()` | Measure and log execution time | Performance monitoring of async tasks |
| `identify()` | Link session to a specific user | Post-login tracking |
| `reset()` | Clear user identity | User logout |
| `screen()` | Manual screen transition | Deep-linked or modal screens |

## Best Practices

### 1. Always Log Errors

Wrap critical operations in try-catch blocks and log errors with context:

```dart
try {
  await criticalOperation();
} catch (e, stackTrace) {
  await postHog.logError('operation_failed', e, stackTrace: stackTrace);
  // Handle error appropriately
}
```

### 2. Use Consistent Naming

- Use `snake_case` for event names: `item_created`, `family_joined`
- Use descriptive names that clearly indicate the action
- Group related events with prefixes: `auth_login`, `auth_logout`, `auth_register`

### 3. Include Relevant Context

Always include context that helps debug issues:

```dart
await postHog.logError(
  'item_creation_failed',
  e,
  context: {
    'user_id': userId,
    'family_id': familyId,
    'item_name': itemName,
    'has_image': hasImage,
  },
);
```

### 4. Don't Log Sensitive Data

Never log:
- Passwords
- Authentication tokens
- Credit card numbers
- Personal identification numbers
- Any PII that shouldn't be in analytics

### 5. Track Important User Actions

Focus on actions that help understand user behavior:
- Feature usage
- User flows
- Error encounters
- Performance bottlenecks

### 6. Log Firestore Operations

Especially important for debugging permission issues:

```dart
await postHog.logFirestoreOperation(
  operation: 'read',
  collection: 'items',
  success: false,
  error: 'permission-denied',
);
```

## Viewing Data

### PostHog Dashboard

Access the dashboard at: https://eu.i.posthog.com

### Key Features

1. **Live Events**
   - Navigate to "Activity" → "Live Events"
   - See events in real-time as they happen
   - Filter by event type, user, or properties

2. **Session Replay**
   - Navigate to "Session Replay"
   - Watch recordings of user sessions
   - Identify UX issues and bugs visually

3. **Persons**
   - View identified users
   - See user properties and event history
   - Track user journeys

4. **Insights**
   - Create custom dashboards
   - Analyze trends and patterns
   - Track KPIs

5. **Errors**
   - Filter for `error_*` events
   - Group by error type
   - Track error frequency and impact

## Debug Mode

PostHog runs in debug mode when the app is in debug mode (`kDebugMode`). This provides:
- Verbose console logging
- Immediate event sending
- Detailed error messages

In production, debug mode is automatically disabled for better performance.

## Troubleshooting

### Events Not Appearing

1. Check console for initialization message: "PostHog initialized successfully"
2. Verify API key and host are correct
3. Check network connectivity
4. Look for error messages in console

### Session Replay Not Working

1. Ensure app is running on a physical device or emulator (not web)
2. Check that session replay is enabled in PostHog project settings
3. Verify Android manifest has correct configuration

### Missing User Properties

1. Ensure `identify()` is called after successful authentication
2. Check that properties are being passed correctly
3. Verify user is logged in when properties are set

## Integration Examples

### Storage Service Integration

Log file operations and transformations automatically within `StorageService`:

```dart
Future<void> uploadFile(String path, File file) async {
  return await PostHogService().trackLatency('storage_upload', () async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putFile(file);
      await PostHogService.log('Storage UPLOAD: $path');
    } catch (e) {
      PostHogService().logError('storage_upload_failed', e, context: {'path': path});
      rethrow;
    }
  });
}
```

### Biometric Service Integration

Track authentication attempts and device configuration changes:

```dart
Future<bool> authenticate() async {
  return await PostHogService().trackLatency('biometric_authenticate', () async {
    try {
      final result = await _auth.authenticate(...);
      await PostHogService.log('Biometric AUTH: ${result ? 'success' : 'failed'}');
      return result;
    } catch (e) {
      PostHogService().logError('biometric_auth_failed', e);
      return false;
    }
  });
}
```

### Auth Service Integration

Track the user lifecycle and ensure correct identification:

```dart
Future<User?> signInWithGoogle() async {
  return await PostHogService().trackLatency('auth_signin_google', () async {
    try {
      final user = await _performGoogleSignIn();
      
      // Identify user and log event
      await _postHog.identify(userId: user.uid, userProperties: {...});
      await PostHogService.log('auth_login', context: {'method': 'google'});
      
      return user;
    } catch (e) {
      PostHogService().logError('auth_login_failed', e, context: {'method': 'google'});
      rethrow;
    }
  });
}
```

## Privacy Considerations

### Data Collection

PostHog collects:
- User identifiers (UIDs)
- Event data and properties
- Screen recordings (session replay)
- Device information
- App version and platform

### User Privacy

- Session replay can be disabled per user if needed
- Sensitive text fields can be masked in session replay
- Users should be informed about analytics in your privacy policy
- Consider GDPR compliance for EU users

### Configuration Options

To mask sensitive data in session replay:

```dart
final config = PostHogConfig(_apiKey);
config.sessionReplayConfig = PosthogSessionReplayConfig(
  maskAllTexts: true,  // Mask all text
  maskAllImages: true, // Mask all images
);
```

## Maintenance

### Updating PostHog

To update to the latest version:

```bash
flutter pub upgrade posthog_flutter
```

Check the [changelog](https://pub.dev/packages/posthog_flutter/changelog) for breaking changes.

### Monitoring Usage

Regularly check PostHog dashboard for:
- Error rates
- User engagement
- Feature adoption
- Performance metrics

## Support

- **PostHog Docs**: https://posthog.com/docs
- **PostHog Community**: https://posthog.com/questions
- **Package Issues**: https://github.com/PostHog/posthog-flutter/issues
