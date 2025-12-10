# Firebase Connection Testing Guide

This document explains the Firebase connection tests and how to use them.

## Overview

The Firebase connection test workflow validates that your Firebase configuration is correct before attempting to build and deploy your app.

## Test Workflow

**File**: `.github/workflows/firebase-test.yml`

### What It Tests

1. **Configuration Files**
   - ✅ `android/app/google-services.json` exists
   - ✅ `lib/firebase_options.dart` exists
   - ✅ `ios/Runner/GoogleService-Info.plist` exists (if iOS configured)

2. **File Validation**
   - ✅ Valid JSON structure in `google-services.json`
   - ✅ Required fields present (project_id, app_id)
   - ✅ Firebase options properly configured

3. **Code Validation**
   - ✅ Firebase initialization in `main.dart`
   - ✅ Firebase packages in `pubspec.yaml`
   - ✅ Proper imports and setup

4. **Integration Tests**
   - ✅ Firebase options validation
   - ✅ API key format check
   - ✅ App ID format validation
   - ✅ Project ID validation

## Running Tests

### Locally

```bash
# Run Firebase integration tests
flutter test test/firebase_test.dart

# Run all tests
flutter test

# Run with verbose output
flutter test test/firebase_test.dart --reporter expanded
```

### In CI/CD

The test workflow runs automatically on:
- Push to `main` or `develop` branches
- Pull requests to `main`
- Manual trigger via GitHub Actions

## Test Coverage

### 1. Configuration File Tests

```yaml
- Verify google-services.json exists
- Validate JSON structure
- Check required fields:
  - project_info.project_id
  - client[0].client_info.mobilesdk_app_id
```

### 2. Firebase Options Tests

```dart
✅ API key is not empty or placeholder
✅ App ID follows format: 1:xxx:android:xxx
✅ Project ID is valid
✅ Messaging sender ID is numeric
✅ Storage bucket format (if used)
```

### 3. Initialization Tests

```dart
✅ Firebase can initialize with current platform
✅ No errors during initialization
✅ Options are properly loaded
```

## Troubleshooting

### Test Failures

#### "google-services.json NOT found"

**Solution**:
1. Download from Firebase Console
2. Place in `android/app/google-services.json`
3. Commit to repository

#### "firebase_options.dart NOT found"

**Solution**:
```bash
# Run FlutterFire CLI
flutterfire configure
```

#### "Invalid JSON structure"

**Solution**:
1. Validate JSON: `jq empty android/app/google-services.json`
2. Re-download from Firebase Console if corrupted

#### "Firebase initialization missing"

**Solution**:
Add to `lib/main.dart`:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

### Integration Test Failures

#### "API key format invalid"

Check that your API key:
- Is not a placeholder (`YOUR_API_KEY`)
- Is at least 20 characters
- Comes from Firebase Console

#### "App ID format invalid"

App ID should match: `1:123456789:android:abcdef123456`

Check in Firebase Console → Project Settings → Your apps

## CI/CD Integration

### Workflow Triggers

```yaml
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  workflow_dispatch:  # Manual trigger
```

### Manual Trigger

1. Go to GitHub → Actions
2. Select "Firebase Connection Test"
3. Click "Run workflow"
4. Select branch
5. Click "Run workflow"

## Test Output Example

```
🔍 Checking Firebase configuration files...
✅ Android google-services.json found
✅ firebase_options.dart found

🔍 Validating google-services.json structure...
✅ Valid JSON structure
✅ Project ID found: seasonbox-prod
✅ App ID found: 1:123456789:android:abc123

🔍 Validating firebase_options.dart...
✅ FirebaseOptions class found
✅ API key configuration found
✅ Project ID configuration found

🧪 Running Firebase integration tests...
✅ All tests passed (8/8)

📊 Firebase Connection Test Summary
====================================
✅ All Firebase configuration checks passed!

Configuration Status:
  - google-services.json: ✅
  - firebase_options.dart: ✅
  - Firebase packages: ✅
  - Firebase initialization: ✅

Your Firebase connection is properly configured! 🎉
```

## Best Practices

1. **Run tests before pushing**
   ```bash
   flutter test test/firebase_test.dart
   ```

2. **Keep configuration files updated**
   - Re-run `flutterfire configure` after Firebase changes
   - Update `google-services.json` when adding services

3. **Don't commit sensitive data**
   - `google-services.json` is safe to commit (contains public config)
   - Never commit service account keys
   - Use GitHub Secrets for sensitive data

4. **Monitor test results**
   - Check GitHub Actions after each push
   - Fix failures immediately
   - Review test coverage regularly

## Adding Custom Tests

To add more Firebase tests, edit `test/firebase_test.dart`:

```dart
test('Your custom test', () {
  // Your test code
  expect(something, isTrue);
});
```

## Related Workflows

- **Build & Deploy**: `.github/workflows/firebase-distribution.yml`
- **Firebase Test**: `.github/workflows/firebase-test.yml` (this file)

## Resources

- [Firebase Flutter Setup](https://firebase.google.com/docs/flutter/setup)
- [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup#configure-flutterfire)
- [Flutter Testing](https://docs.flutter.dev/testing)
