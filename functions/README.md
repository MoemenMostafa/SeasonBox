# SeasonBox Cloud Functions

This directory contains the Firebase Cloud Functions for the SeasonBox application.
Currently, it hosts a background trigger to send invitation emails when a family member is added or their invite status changes to `pending`.

## Prerequisites

- **Node.js**: Version 18 (as specified in `engines` field of `package.json`).
- **Firebase CLI**: Install globally via `npm install -g firebase-tools`.

## Setup

1.  **Navigate to the functions directory:**
    ```bash
    cd functions
    ```

2.  **Install dependencies:**
    ```bash
    npm install
    ```

## Configuration

The email sender is configured to use **Gmail** via `nodemailer`. You must provide your Gmail credentials as Firebase environment variables.

> **Note:** For Gmail, you likely need to generate an **App Password** if you have 2-Step Verification enabled. Do not use your regular password.

Run the following command to set your config (replace with your actual details):

```bash
firebase functions:config:set gmail.email="your-email@gmail.com" gmail.password="your-app-password"
```

## Deployment

To deploy the functions to your Firebase project:

```bash
firebase deploy --only functions
```

## Function Details

### `sendFamilyInvitation`

-   **Trigger**: Firestore `onWrite`
-   **Path**: `families/{familyId}/members/{memberId}`
-   **Logic**:
    -   Monitors the `inviteStatus` field of family member documents.
    -   If `inviteStatus` changes to `'pending'` (or acts as a new pending invite), it triggers an email to the address in `inviteEmail`.
    -   The email contains the `familyId` which the user can use to join.

## Local Testing

To run the functions locally using the Firebase Emulator Suite:

```bash
npm run serve
```
