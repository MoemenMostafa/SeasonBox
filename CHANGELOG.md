# Changelog

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
