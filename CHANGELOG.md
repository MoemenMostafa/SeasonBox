# Changelog

## 1.1.18+23
- **Web Analytics & Enhancements**:
    - **PostHog for Web**: Integrated PostHog JS snippets into Flutter Web (`index.html`) and all landing pages (`web_landing/`).
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
