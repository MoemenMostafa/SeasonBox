# Changelog

## 1.7.6+44
- **Stability & Bug Fixes**:
    - **Unsafe Context Lookup**: Fixed a critical `FlutterError` in `SubscriptionScreen` during screen disposal.
    - **Mounted Checks**: Enhanced application robustness by adding `context.mounted` guards after asynchronous operations.
    - **Lint Compliance**: Resolved all `use_build_context_synchronously` warnings in the subscription feature.

## 1.7.5+43
- **Premium Experience**:
    - **Celebration Screen**: Added a new premium celebration screen with confetti and animations for newly upgraded users.
    - **Seamless Flow**: Implemented automatic navigation to the celebration screen upon successful subscription verification.
    - **Easter Egg**: Added a preview of the celebration screen in the Easter Egg section for discovery.
- **Backend & Infrastructure**:
    - **Enhanced Logging**: Introduced a centralized backend logger that mirrors logs to PostHog for better observability.
    - **Traceability**: Improved session ID correlation between the mobile app and Cloud Functions.

## 1.7.4+42
- **Subscriptions & Billing**:
    - **Restore Purchases**: Implemented "Restore Purchases" functionality on the subscription screen.
    - **Verification Logic**: Fixed critical issues in server-side purchase verification.
    - **Safety Checks**: Improved error handling during the purchase restoration process.
- **Platform & Security**:
    - **App Check**: Enhanced Firebase App Check integration for improved security.
    - **Legal & Compliance**: Updated terms of service and website documentation.

## 1.7.3+41
- **Subscription Store Improvements**:
    - **PostHog Integration**: Implemented comprehensive tracking for the subscription lifecycle (initialization, product loading, purchase updates, and verification).
    - **In-App Diagnostics**: Added specialized diagnostic messaging on the subscription screen to troubleshoot "product unavailable" errors (Store status, Products loaded, Target ID).
    - **Android Compatibility**: Explicitly added billing permissions and package visibility queries to resolve store connectivity issues on Android 11+.
    - **Web Support**: Fixed initialization crash on web platforms.
    - **Legacy Support**: Simplified multi-product logic to use a single Unified Product ID (`premium`) with modern Google Play Base Plans.
    - **Enhanced Debugging**: Added real-time logging of store events to PostHog for easier troubleshooting of device-specific billing issues.

## 1.7.2+40
- **Platform Compatibility**:
    - **Web Fix**: Resolved a critical "Initialization Error" crash on web browsers by guarding in-app purchase services.
- **Subscriptions & Billing**:
    - **Google Play Refactor**: Migrated to a single Product ID (`premium`) with multiple Base Plans (`monthly`, `yearly`) for simplified subscription management.
    - **Live Pricing**: Implemented direct pricing retrieval from Google Play base plans, ensuring users always see accurate local prices.
    - **Base Plan Selection**: Enhanced the purchase flow to support specific base plan selection for a more streamlined user experience.
    - **Documentation**: Added comprehensive subscription pricing and configuration documentation.

## 1.7.1+39
- **Internal Billing Refactor**: Initial implementation of Billing 5+ support and base plan IDs.

## 1.7.0+38
- **Premium Subscriptions**:
    - **Google Play Integration**: Comprehensive support for in-app subscriptions on Android.
    - **Real-Time Verification**: Secure server-side validation of purchases via Firebase Cloud Functions.
    - **Flexible Management**: Automated handling of renewals, cancellations, and billing issues through Google Play RTDN.
    - **Interactive UI**: Real-time pricing display and seamless purchase flow within the app.
- **Organization & Printing**:
    - **QR Code Labels**: Implemented QR code label generation for all storage locations.
    - **PDF Export**: Added ability to export and print professional-grade labels for organizers.
    - **Label Service**: Integrated `LabelService` for high-quality PDF layout and printing support.
 
## 1.6.5+36
- **Storage & Maintenance**:
    - **Automated Cleanup**: implemented daily scheduled maintenance to clean up orphaned images and conserve storage space.
    - **Immediate Removal**: Enhanced item deletion logic to immediately remove associated images from storage.
- **Stability & Bug Fixes**:
    - **Navigation**: Resolved a critical `GoRouter` exception that occurred when popping the last page from the stack.
    - **Visual Polish**: Removed the debug banner for a cleaner production look.
- **UX Improvements**:
    - **Limit Messages**: Standardized "Limit Reached" dialogs across the app for a consistent user experience.

## 1.6.4+35
- **UX & Search**: Implemented a searchable location picker for easier item assignment.
- **Demo Mode**: Restricted data modifications in Demo Mode and added user feedback for a stable preview experience.
- **UI Cleanup**: Removed search bar and non-functional buttons from production UI to streamline the interface.
- **Privacy**: Removed phone number field from user profiles across the app and backend.
- **Performance**: Compressed application icon and optimized web initialization to resolve "Zone mismatch" issues.

## 1.6.3+34
- **UI & UX Refinement**:
    - **Feature Reordering**: Optimized the display order of free and premium benefits on the website and app, placing the most important features (Items and Photos) first.
    - **Store Links**: Connected the "Rate App" button in the app and the Android download button on the website directly to the Google Play Store.
    - **Localization**: Ensured all localized strings are synchronized across the app and website for a consistent experience.

## 1.6.2+33
- **Premium Tier Enhancements**:
    - **Tiered Image Limits**: Implemented and restricted image uploads based on subscription tier (1 image for Free, 3 images for Premium).
    - **Localization**: Added full localization for the "3 photos per item" benefit in the app and website pricing sections across 5 languages (EN, ES, FR, DE, IT).
    - **UI Visibility**: Updated the Subscription Screen and Website pricing tables to clearly display the new tiered photo benefits.
- **CI/CD & Infrastructure**:
    - **Website Deployment**: Created a dedicated GitHub Actions workflow (`deploy-website.yml`) for automatic deployment of the website to Firebase Hosting.
    - **Folder Restructuring**: Renamed `web_landing` to `website` for better project organization.
    - **Authentication**: Fixed CI authentication issues by correctly handling base64 encoded service account keys.
- **Security & Reliability**:
    - **Firestore Rules**: Enforced the 3-image limit in Firestore security rules to prevent unauthorized uploads.
    - **CI Permissions**: Resolved service account permission errors in the Firestore deployment pipeline.

## 1.6.1+32
- **Bug Fixes & Security**:
    - **Item Ownership**: Fixed critical Firestore permission errors by standardizing item ownership field from `memberId` to `ownerId` to match security rules.
    - **Permission Service**: Updated `canDeleteItem` and `canEditItem` methods to use the correct `ownerId` field.
    - **Firestore Rules**: Enhanced security rules for better item access control and validation.
- **Error Handling**:
    - **Structured Exceptions**: Introduced `AppException` class for consistent error handling across the application.
    - **Service Layer**: Improved error handling in `FirestoreService`, `StorageService`, and `RemoteConfigService`.
- **Subscription & Pricing**:
    - **Remote Config Integration**: Enhanced subscription screen to dynamically fetch pricing from Firebase Remote Config.
    - **UI Improvements**: Updated subscription screen layout and pricing display for better user experience.
    - **Localization**: Added and updated subscription-related strings across all supported languages.
- **Website Updates**:
    - **Landing Page**: Refined styling and layout for improved visual appeal and responsiveness.
    - **Localization**: Updated website translations and improved language switching functionality.
- **Testing Infrastructure**:
    - **Firestore Tests**: Added comprehensive test suite for Firestore security rules using the Firebase emulator.
    - **Test Helpers**: Created reusable test utilities for authentication and Firestore operations.

## 1.6.0+31
- **Premium Localization**:
    - **Family Members**: Localized "Limit Reached" dialogs and edit permissions tooltips.
    - **Growth Charts**: Localized premium status messages and "View Pricing" calls to action.
    - **Language Support**: All new premium UI elements are fully translated into English, Spanish, French, German, and Italian.
- **UI & UX**:
    - **Responsive Buttons**: Adjusted button padding in upgrade dialogs to comfortably fit longer translated text (e.g., "Ver Precios").
    - **Growth Chart Polish**: Refined the layout and messaging for the premium growth prediction overlay.

## 1.5.0+30
- **Magic Upload Animation**:
    - **Boxy Masterpiece**: Implemented a high-polish, custom-painted "Magic Upload" animation with Boxy tossing data particles into a magical glowing box.
    - **Adaptive Details**: Animation particles dynamically change based on the item category (Clothes, Shoes, Toys, etc.).
    - **Visual Feedback**: Added a magical upload beam and expressive character behaviors (blinking, breathing) during wait states.
- **UX Standardization & Cleanup**:
    - **Standard Indicators**: Reverted non-critical loading states in `AddFamilyMemberScreen`, `ItemsScreen`, and `AddStorageLocationScreen` to standard Material `CircularProgressIndicator` for a cleaner UI.
    - **System Refactor**: Removed the legacy and over-engineered `contextual_loading_indicator.dart` system.
 
## 1.4.0+29
- **Logging & Monitoring Architecture**:
    - **Service Wrappers**: Implemented consistent logging for all core services (`FirestoreService`, `StorageService`, `AuthService`, `BiometricService`, `UserService`).
    - **Latency Tracking**: Added `trackLatency` to key operations (Firestore reads, image processing, sign-in) for production performance monitoring.
    - **UI Abandonment**: Introduced form drop detection for `AddItem` and `AddFamilyMember` screens to identify UX friction points.
    - **Enhanced Error Context**: Standardized error logging with document paths, collection names, and user state to accelerate debugging.
- **Documentation**:
    - **Integrated PostHog Docs**: Updated `docs/posthog_integration.md` with the new standardized logging patterns and performance monitoring guide.

## 1.3.0+28
- **Navigation Redesign**:
    - **Central "Add Item" FAB**: Added a prominent floating action button in the center of the bottom navigation bar for quick access to adding items.
    - **Refined Tabs**: Split navigation into Home/Items (left) and Members/Storage (right) with a modern notched bottom bar.
    - **Standalone Profile**: Moved the Profile screen to a dedicated route, accessible via the user avatar on the Dashboard.
- **Performance & UX**:
    - **Immediate Image Processing**: Images are now compressed and thumbnails generated immediately after capture, significantly reducing save times.
    - **"Save & Add Another"**: Added a high-efficiency workflow for adding multiple items, preserving common fields like Size, Location, and Member.

## 1.2.1+27
- **Authentication & Security**:
    - **Optimized Google Login**: Improved family linking logic to skip redundant Cloud Function calls for previously linked users.
    - **Comprehensive Test Suite**: Implemented a robust authentication flow test suite covering Google Login, Email Registration, Family Join/Leave, and Biometric authentication.
- **Growth Chart & Localization**:
    - **"No Growth" Insights**: Added intelligent growth insights for cases where no significant growth is expected (e.g., reached max growth age).
    - **Expanded Localization**: Fully localized the new growth insights across English, French, Spanish, German, and Italian.
    - **Prediction Refinement**: Updated shoe size prediction models to reflect gender-specific maximum growth ages and EU growth patterns.

## 1.2.0+26
- **Item Tagging & Search**:
    - **Tag Management**: Added ability to add custom tags (up to 5) to items with autocomplete and frequency-based suggestions.
    - **Advanced Search**: Implemented a search bar in the Items list that filters by title, category, and tags.
    - **UI Enhancement**: tags are now displayed as clickable hashtags on item cards.
    - **Deep Localization**: Full translation for tagging features across all 5 supported languages.
- **Sizing & Measurement**:
    - **Dynamic Sizing**: Implemented conditional size selection (Metric vs. Imperial) based on user profile settings.
    - **Unified Experience**: Standardized sizing controls across `AddItemScreen` and `AddFamilyMemberScreen`.
- **Growth Chart Refinement**:
    - **Localization**: Finalized the translation of all growth chart strings.
    - **Visual Polish**: Fixed UI overflow and linting issues in the `GrowthChartScreen`.
- **UI/UX Improvements**:
    - **Accessibility**: Increased touch targets on the Storage screen to prevent "fat finger" errors.
    - **Auto-Assignment**: New items are now automatically assigned to the current member user if they are not an admin.
    - **Bug Fixes**: Resolved layout issues in `AddItemScreen` and optimized code structure.

## 1.1.20+25
- **CI Stability & Maintenance**:
    - **Test Fixes**: Resolved `widget_test.dart` failures by properly initializing Firebase mocks and fixing UI overflow issues in the test environment.
    - **Lint Resolutions**: Fixed numerous `use_build_context_synchronously` warnings and other code quality issues.
    - **Dependency Update**: Migrated from deprecated `Share` methods to the latest `share_plus` API.
    - **CI Optimization**: Added disk space cleanup and path filtering to GitHub Actions workflows to improve build reliability and speed.

## 1.1.19+24
- **PostHog Enhancements**:
    - **PostHog Session Replay**: Fixed blank recordings by wrapping `MaterialApp` with `PostHogWidget`.
    - **User Identification**: Enhanced analytics by linking PostHog sessions with user email addresses upon login and registration.

## 1.1.18+23
- **Web Analytics & Enhancements**:
    - **PostHog for Web**: Integrated PostHog JS snippets into Flutter Web (`index.html`) and all landing pages (`website/`).
    - **Unified Web Tracking**: Enabled seamless session replay and analytics tracking across the landing page and main web app.
    - **Web Console Recording**: Enabled `enable_recording_console_log` to capture browser console logs in web session replays.
    - **Optimization**: Disabled `AUTO_INIT` in Android configuration to ensure controlled initialization via `PostHogService`.

## 1.1.17+22
- **Analytics & Monitoring Refactor**:
    - **Explicit Logging**: Replaced all `debugPrint` calls throughout the app with `PostHogService.log()` for consistent production monitoring.
    - **Clean Logging API**: Simplified `PostHogService` with a singleton pattern and a single `log()` method.
    - **Type-Safe Log Levels**: Refactored logging levels to use a `LogLevel` enum for better consistency and error prevention.
    - **Removed debugPrint Redirection**: Reverted global `debugPrint` redirection to avoid recursion and allow standard console behavior in debug builds.
    - **Session Replay Maintenance**: Ensured session replay remains functional with improved logging.

## 1.1.16+21
- **Analytics & Monitoring**:
    - **Session Replay**: Enabled screen recording for all builds (debug and release) to capture user interactions and debug issues.
    - **Production Logging**: Implemented `logToPostHog()` method to send logs to PostHog dashboard instead of device console in release builds.
    - **Global Exception Capture**: Added automatic capture of all Flutter errors and async exceptions to PostHog.
    - **Android API Fix**: Updated minSdkVersion to 26 (required for PostHog session replay).
    - **Test Logging**: Added automatic test logs on app startup to verify PostHog integration.

## 1.1.15+20
- **Bug Fixes**:
    - **Dropdown Validation**: Fixed a critical error in the Add Item screen where the storage location dropdown would crash when the items list was empty. The dropdown now properly handles empty states by setting both value and items to null when no locations are available.

## 1.1.14+19
- **Analytics & Monitoring**:
    - **PostHog Integration**: Integrated PostHog for comprehensive analytics, session replay, and live debugging.
    - **Event Tracking**: Implemented automatic tracking for user actions, screen views, and app lifecycle events.
    - **Debug Logging**: Added extensive logging capabilities for errors, warnings, network calls, permissions, and Firestore operations.
    - **Session Replay**: Enabled session recording for debugging live user sessions and identifying issues.

## 1.1.13+18
- **Security & Performance**:
    - **Cloud Functions Registration**: Migrated user registration and family joining logic to Cloud Functions, eliminating client-side permission issues and improving security.
    - **Enhanced Security Rules**: Completely redesigned Firestore security rules with proper member validation using `userId` field.
    - **Simplified Permissions**: Streamlined data access rules for better performance and reliability.
- **Bug Fixes**:
    - **Registration Flow**: Fixed persistent "permission denied" errors during registration and family joining.
    - **Data Loading**: Resolved permission issues when querying items, members, and locations after login.

## 1.1.12+17
- **UI Improvements**:
    - **Pull to Refresh**: Added pull-to-refresh functionality to both the **Profile Screen** and **Storage Screen**. Users can now manually reload their data by pulling down on these screens.

## 1.1.11+16
- **Bug Fixes & Stability**:
    - **Registration Flow**: Fixed a critical issue where registering with a Family ID created a duplicate member instead of linking to the invited profile. Logic now correctly "claims" pending invitations.
    - **Notifications**: Fixed missing Firestore indexes that prevented in-app invitation notifications from loading.

## 1.1.10+15
- **Bug Fixes & Stability**:
    - **Permissions Fix**: Resolved a critical race condition when joining families that caused "Permission Denied" errors and invisibility of family members/locations. Family transitions are now atomic.
- **UI Improvements**:
    - **Login Screen**: Adjusted background icon positioning for better layout on authentication screens.

## 1.1.9+14
- **Notifications & Invitations**:
    - **In-App Notifications**: Implemented a new Notifications screen to view and manage incoming family invitations.
    - **Accept/Reject Actions**: Users can now accept or reject invitations directly within the app.
    - **Localization**: Added full translation support for notification messages and actions.
- **Backend & Security**:
    - **Firestore Rules**: Updated security rules to allow secure "Collection Group Queries" for fetching user-specific pending invites.

## 1.1.8+13
- **Help Center & Web Landing**:
    - **Contact Form Security**: Refactored the "Contact Us" form to use a secure JavaScript-based `mailto` generator, resolving "not secure" browser warnings.
    - **Scroll Positioning**: Added a smart scroll buffer to the "Contact Us" anchor (`#contact`) so the section title is no longer hidden behind the fixed header.
    - **Invitation Tutorial**: Corrected the "Sending Family Invitations" tutorial guide to match the actual app workflow (Member View -> Edit Member -> Invitation).
    - **Localization**: Cleaned up duplicate translation keys and ensured consistent messaging across all 5 languages.
    - **Profile Screen**: Updated the "Help Center" and "Contact Support" links to point to the production domain (`seasonbox.app`) instead of the staging URL.

## 1.1.7+12
- **Help Center**:
    - **New Help Page**: Created a comprehensive Help Center (`/help.html`) with FAQs and Tutorials in an accordion layout.
    - **Invitation Guide**: Added a dedicated "Sending Family Invitations" tutorial.
    - **Contact Support**: Added a "Contact Us" form (via mailto) and linked the Profile Screen's "Contact Support" button directly to it.
    - **Localization**: Fully translated Help Center into English, German, Spanish, French, and Italian.
- **Web Landing**:
    - **Footer Links**: Updated footers on all pages (Home, Privacy, Terms) to include links to the Help Center and Contact Us.
    - **Deep Linking**: Enhanced `script.js` to support deep linking to specific sections (e.g., `/help#contact`) with language prefixes.

## 1.1.6+11
- **Authentication**:
    - **Biometric Social Login**: Enabled seamless biometric authentication for Google Sign-In, allowing users to re-authenticate without re-entering credentials.
- **UI/UX Enhancements**:
    - **Profile Screen**: Updated the Family Management section to display Family ID and Name strictly as informational text, removing the button interaction.
    - **Web Landing**: Implemented path-based localization (e.g., `/en/home`) for better SEO and direct linking support.
- **Backend**:
    - **Cloud Functions**: Fully migrated the "Send Invitation" email logic to Firebase Cloud Functions triggered by Firestore writes, removing client-side dependencies.

## 1.1.5+10
- **Family Management (Refined)**:
    - **Creator Rules**: Family creators (Admins) who have other members must now "Disband" (remove all members) their current family before they are allowed to join a new one.
    - **Disband Warning**: Added a specific warning dialog when a creator attempts to leave their family, clarifying that the group will be deleted.
    - **Invitation Security**: Enforced strict email matching. Users cannot join a family if their logged-in email does not match the invited email address.
- **Documentation**:
    - Added `docs/family_architecture.md` detailing the User-Family data model and secure invitation workflow.
- **Bug Fixes**:
    - **Profile Crash**: Fixed a "gray box" crash on the Profile screen for newly registered users (handled null family names).
    - **Logout Error**: Fixed a crash on physical devices where `secure_storage` key invalidation (BadPaddingException) prevented users from logging out.
    - **Biometric Robustness**: Added global error handling to `BiometricService` to prevent crashes when accessing corrupted secure storage.

## 1.1.4+9
- **Item Management**:
    - Implemented **Swipe-to-Delete** for items in the main list, including undo/confirmation.
    - Added a **Delete Button** to the "Edit Item" screen with confirmation dialog.
- **Family Management**:
    - **Secure Join**: Users can now securely join families via the Profile screen or Registration page. Joining requires an active email invitation.
    - **Leave Family**: Users can leave their current family and return to a personal space.
- **Bug Fixes**:
    - Fixed a type error in `UserService` where Firestore data was not being correctly cast to a Map, preventing family joining logic from working properly.

## 1.1.3+8
- Implemented **Invitation Management**:
    - Added "Cancel Invitation" functionality for pending invites.
    - Enabled updating email address for pending invitations.
    - Improved "Resend Invite" logic to be more reliable.
    - **Optimization**: Prevented unwanted invitation emails when updating member details (name, notes, etc.).
- **Cloud Functions**:
    - Fixed Gmail authentication issues by supporting App Passwords.
    - Refined email triggering logic based on `lastInviteSent` timestamp.
- **UI/UX**:
    - Refined email input field styling in `AddFamilyMemberScreen` to match app theme.
    - Added bottom padding to `FamilyMembersScreen` list to prevent FAB obstruction.
- **Localization**:
    - Added comprehensive translations for new invitation management features (English, Spanish, German, French, Italian).

## 1.1.2+7
- Migrated `sendFamilyInvitation` to Cloud Functions 2nd Gen for better security and reliability.
- Upgraded `firebase-functions` to v7 and Node.js runtime to v22.
- Implemented Google Cloud Secret Manager for secure environment configuration.
- Fixed `firebase.json` deployment configuration.
- Initialized Firebase project location.

## 1.1.1+6
- Centralized user role management using `UserRole` enum.
- Removed 'child' role from family member options.
- Updated `AddFamilyMemberScreen` and `EditProfileScreen` to use unified role selection.
- Fixed localization coverage for roles.
- Fixed bug where profile role changes were not being saved.
- Fixed Profile Screen showing hardcoded 'Admin' role.
- Standardized styling in `AddFamilyMemberScreen` and `EditProfileScreen` to match app theme.
- Added user profile picture to the app bar header.
- Tapping the profile picture in the header now navigates to the Profile tab.
