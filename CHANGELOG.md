# Changelog

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
