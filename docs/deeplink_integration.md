# Deep Link Integration Guide

SeasonBox supports deep linking via both Custom URL Schemes and platform-native link handling (Android App Links and Apple Universal Links). This allows users to navigate directly to specific app sections from external sources.

## Overview

- **Custom Scheme**: `seasonbox://`
- **Domain**: `https://seasonbox.app`
- **Parameter Support**: Handles both path parameters and query parameters using `GoRouter`.

## Platform Configuration

### Android

Configured in `android/app/src/main/AndroidManifest.xml`.

#### Intent Filters
The `MainActivity` includes intent filters for both the custom scheme and the HTTPS domain:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" android:host="seasonbox.app" />
    <data android:scheme="http" android:host="seasonbox.app" />
</intent-filter>

<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="seasonbox" />
</intent-filter>
```

### iOS

Requires manual configuration of `Info.plist` (for URL schemes) and `Runner.entitlements` (for Universal Links).

## Web Association Files

These files are located in the `website/.well-known/` directory and must be served from the top-level of the domain.

### Android App Links (`assetlinks.json`)
Maps the domain to the app's package name (`io.mos.seasonbox`) and SHA-256 fingerprints.

### Apple Universal Links (`apple-app-site-association`)
Maps the domain to the app's App ID (`TEAM_ID.io.mos.seasonbox`).

## Routing & Deep Link Parameters

Routing logic is handled in `lib/app/routes/router.dart`. Specifically, the following routes support parameters via deep links:

### Storage Screen
- **Route**: `/storage`
- **Parameters**: `id` (Query Parameter)
- **Behavior**: Highlights the specific storage location.
- **Example**: `seasonbox://storage?id=location_123`

### Items Screen
- **Route**: `/items`
- **Parameters**: `memberId`, `locationId` (Query Parameters)
- **Behavior**: Filters items by the specified member or storage location.
- **Example**: `seasonbox://items?memberId=member_abc&locationId=location_xyz`

## Analytics (PostHog)

Deep link openings are tracked via PostHog. The `deeplink_opened` event is captured within the `GoRouter` builder when relevant parameters are present.

### Captured Event Properties
- `route`: The target app route.
- `locationId`: (Optional) The location ID if provided.
- `memberId`: (Optional) The member ID if provided.

## Verification Commands

### Android (ADB)
```bash
adb shell am start -a android.intent.action.VIEW \
    -d "seasonbox://storage?id=test_location" \
    io.mos.seasonbox
```

### iOS (simctl)
```bash
xcrun simctl openurl booted "seasonbox://items?memberId=test_member"
```
