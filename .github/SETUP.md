# GitHub Actions Setup for Firebase App Distribution

This guide will help you set up the GitHub Actions workflow to automatically build and deploy your Flutter app to Firebase App Distribution.

## Prerequisites

1. A Firebase project with App Distribution enabled
2. An Android app registered in Firebase
3. A release keystore for signing your Android app
4. A Firebase service account with appropriate permissions

## Required GitHub Secrets

You need to add the following secrets to your GitHub repository:

### 1. FIREBASE_SERVICE_ACCOUNT_KEY

**What it is**: A base64-encoded Firebase service account JSON key file.

**How to get it**:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to Project Settings → Service Accounts
4. Click "Generate New Private Key"
5. Download the JSON file
6. Convert it to base64:
   ```bash
   base64 -i path/to/service-account.json | pbcopy
   ```
7. Add it to GitHub Secrets as `FIREBASE_SERVICE_ACCOUNT_KEY`

### 2. FIREBASE_APP_ID

**What it is**: Your Firebase Android app ID (format: `1:123456789:android:abcdef123456`)

**How to get it**:
1. Go to Firebase Console → Project Settings
2. Scroll to "Your apps" section
3. Click on your Android app
4. Copy the "App ID"
5. Add it to GitHub Secrets as `FIREBASE_APP_ID`

### 3. KEYSTORE_BASE64

**What it is**: Your Android release keystore file, base64-encoded.

**How to create and encode**:

If you don't have a keystore yet:
```bash
keytool -genkey -v -keystore release-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release
```

Then encode it:
```bash
base64 -i release-keystore.jks | pbcopy
```

Add it to GitHub Secrets as `KEYSTORE_BASE64`

### 4. KEYSTORE_PASSWORD

**What it is**: The password you used when creating the keystore.

Add it to GitHub Secrets as `KEYSTORE_PASSWORD`

### 5. KEY_ALIAS

**What it is**: The alias you used when creating the keystore (e.g., "release").

Add it to GitHub Secrets as `KEY_ALIAS`

### 6. KEY_PASSWORD

**What it is**: The key password (often the same as keystore password).

Add it to GitHub Secrets as `KEY_PASSWORD`

## How to Add Secrets to GitHub

1. Go to your GitHub repository
2. Click on "Settings"
3. In the left sidebar, click "Secrets and variables" → "Actions"
4. Click "New repository secret"
5. Add each secret with its name and value
6. Click "Add secret"

## Firebase App Distribution Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to "App Distribution" in the left menu
4. If not already set up, follow the setup wizard
5. Create a tester group named "testers" (or modify the workflow file to use a different group name)
6. Add testers to the group using their email addresses

## Update build.gradle for Signing

Make sure your `android/app/build.gradle` is configured to use the keystore:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... other config

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            // ... other release config
        }
    }
}
```

## Testing the Workflow

1. Push your code to the `main` or `develop` branch
2. Go to the "Actions" tab in your GitHub repository
3. You should see the workflow running
4. Once complete, check Firebase App Distribution for the new build

## Manual Trigger

You can also manually trigger the workflow:
1. Go to the "Actions" tab
2. Select "Build and Deploy to Firebase App Distribution"
3. Click "Run workflow"
4. Select the branch and click "Run workflow"

## Troubleshooting

### Build fails with "Process finished with non-zero exit value 1"
- Check that all secrets are correctly set
- Verify your keystore credentials are correct
- Check the workflow logs for specific error messages

### Firebase upload fails
- Verify `FIREBASE_APP_ID` is correct
- Check that the service account has "Firebase App Distribution Admin" role
- Ensure App Distribution is enabled in your Firebase project

### Keystore issues
- Make sure the keystore is properly base64-encoded
- Verify the alias and passwords match what you used when creating the keystore

## Customization

You can customize the workflow by editing `.github/workflows/firebase-distribution.yml`:

- **Change trigger branches**: Modify the `on.push.branches` section
- **Change tester group**: Modify the `groups` parameter in the Firebase upload step
- **Add iOS builds**: Add additional steps for iOS builds (requires macOS runner)
- **Modify release notes**: Edit the `releaseNotes` section

## Security Notes

- Never commit your keystore or service account files to the repository
- Always use GitHub Secrets for sensitive data
- The workflow automatically cleans up sensitive files after the build
- Keep your secrets secure and rotate them periodically
