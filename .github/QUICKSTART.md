# Quick Start: GitHub Actions + Firebase App Distribution

## 🚀 Quick Setup (5 minutes)

### Step 1: Create a Keystore (if you don't have one)

```bash
cd android/app
keytool -genkey -v -keystore release-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias release
```

**Save these values** - you'll need them for GitHub Secrets:
- Keystore password
- Key password  
- Key alias (e.g., "release")

### Step 2: Get Firebase Service Account

1. Go to [Firebase Console](https://console.firebase.google.com/) → Your Project
2. Project Settings → Service Accounts
3. Click "Generate New Private Key"
4. Download the JSON file

### Step 3: Get Firebase App ID

1. Firebase Console → Project Settings
2. Under "Your apps", click your Android app
3. Copy the **App ID** (format: `1:123456789:android:abcdef123456`)

### Step 4: Add GitHub Secrets

Go to your GitHub repo → Settings → Secrets and variables → Actions

Add these 6 secrets:

| Secret Name | Value | How to Get |
|------------|-------|------------|
| `FIREBASE_SERVICE_ACCOUNT_KEY` | Base64 of service account JSON | `base64 -i service-account.json \| pbcopy` |
| `FIREBASE_APP_ID` | Your Firebase app ID | From Firebase Console (Step 3) |
| `KEYSTORE_BASE64` | Base64 of keystore file | `base64 -i release-keystore.jks \| pbcopy` |
| `KEYSTORE_PASSWORD` | Your keystore password | From Step 1 |
| `KEY_ALIAS` | Your key alias | From Step 1 (e.g., "release") |
| `KEY_PASSWORD` | Your key password | From Step 1 |

### Step 5: Set Up Firebase App Distribution

1. Firebase Console → App Distribution
2. Click "Get Started" if not set up
3. Create a tester group named **"testers"**
4. Add tester emails to the group

### Step 6: Test the Workflow

```bash
git add .
git commit -m "Add GitHub Actions workflow"
git push origin main
```

Go to GitHub → Actions tab to watch the build!

---

## 📱 What Happens Next?

When you push to `main` or `develop`:

1. ✅ Code is checked out
2. ✅ Flutter & Java are set up
3. ✅ Dependencies are installed
4. ✅ Tests run (optional)
5. ✅ APK & App Bundle are built
6. ✅ APK is uploaded to Firebase App Distribution
7. ✅ Testers receive email notifications
8. ✅ Build artifacts are saved to GitHub

---

## 🔧 Local Testing (Optional)

To test builds locally with your keystore:

1. Copy the example file:
   ```bash
   cp android/key.properties.example android/key.properties
   ```

2. Edit `android/key.properties` with your values:
   ```properties
   storePassword=your_password
   keyPassword=your_password
   keyAlias=release
   storeFile=release-keystore.jks
   ```

3. Build locally:
   ```bash
   flutter build apk --release
   ```

---

## 🐛 Troubleshooting

### "Process finished with non-zero exit value 1"
- Check all 6 GitHub secrets are set correctly
- Verify keystore credentials match

### "Firebase upload failed"
- Verify `FIREBASE_APP_ID` is correct (should start with `1:`)
- Check service account has "Firebase App Distribution Admin" role

### "Keystore not found"
- Make sure you base64-encoded the keystore file correctly
- Verify the keystore file exists locally

---

## 📚 Full Documentation

For detailed information, see [SETUP.md](.github/SETUP.md)

---

## 🎯 Manual Trigger

You can manually trigger a build:

1. GitHub → Actions tab
2. Select "Build and Deploy to Firebase App Distribution"
3. Click "Run workflow"
4. Select branch → Run workflow

---

## 🔐 Security Checklist

- ✅ `key.properties` is in `.gitignore`
- ✅ `*.jks` files are in `.gitignore`
- ✅ Never commit keystore or service account files
- ✅ All secrets are in GitHub Secrets (not in code)
