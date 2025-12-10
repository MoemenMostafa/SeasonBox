# Fixing HTTP 403 Error - Firebase App Distribution

## Problem

You're getting this error when trying to upload to Firebase App Distribution:

```
Error: failed to upload ***. HTTP Error: 403, The caller does not have permission
```

## Root Cause

The **service account** used in GitHub Actions doesn't have the required permissions to upload to Firebase App Distribution.

## Solution

### Step 1: Verify Your Service Account Email

First, let's find your service account email:

```bash
# Decode your service account to see the email
echo "$FIREBASE_SERVICE_ACCOUNT_KEY" | base64 --decode | jq -r '.client_email'
```

Or check the JSON file you downloaded from Firebase:
```bash
jq -r '.client_email' service-account.json
```

The email will look like: `firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com`

### Step 2: Grant Required Permissions

#### **Option A: Using Firebase Console (Recommended)**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click the gear icon → **Project Settings**
4. Go to **Service Accounts** tab
5. You'll see your service account email
6. Click **Manage service account permissions** (opens Google Cloud Console)
7. Find your service account in the list
8. Click the **pencil icon** (Edit) next to it
9. Click **+ ADD ANOTHER ROLE**
10. Search for and add: **Firebase App Distribution Admin**
11. Click **Save**

#### **Option B: Using Google Cloud Console**

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to **IAM & Admin** → **IAM**
4. Find your service account (the email from Step 1)
5. Click **Edit** (pencil icon)
6. Click **+ ADD ANOTHER ROLE**
7. Add role: **Firebase App Distribution Admin**
8. Click **Save**

#### **Option C: Using gcloud CLI**

```bash
# Replace with your values
PROJECT_ID="your-project-id"
SERVICE_ACCOUNT_EMAIL="firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com"

# Grant Firebase App Distribution Admin role
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/firebaseappdistro.admin"
```

### Step 3: Verify Permissions

After granting permissions, verify they're set correctly:

```bash
# List all roles for your service account
gcloud projects get-iam-policy $PROJECT_ID \
  --flatten="bindings[].members" \
  --filter="bindings.members:serviceAccount:$SERVICE_ACCOUNT_EMAIL"
```

You should see `roles/firebaseappdistro.admin` in the output.

### Step 4: Re-run GitHub Actions

Once permissions are granted:

1. Go to your GitHub repository
2. Click **Actions** tab
3. Select the failed workflow
4. Click **Re-run jobs** → **Re-run failed jobs**

The upload should now succeed! ✅

## Required Roles Summary

For Firebase App Distribution, your service account needs:

| Role | Purpose | Required |
|------|---------|----------|
| **Firebase App Distribution Admin** | Upload and manage app releases | ✅ Yes |
| **Service Account User** | Use service account credentials | Usually auto-granted |

## Troubleshooting

### Still Getting 403 Error?

1. **Wait a few minutes**: IAM changes can take 1-2 minutes to propagate

2. **Check the App ID**: Verify `FIREBASE_APP_ID` secret matches your Firebase app
   ```bash
   # In Firebase Console → Project Settings → Your apps
   # Copy the App ID (format: 1:123456789:android:abc123)
   ```

3. **Verify service account is for correct project**:
   ```bash
   jq -r '.project_id' service-account.json
   ```
   Should match your Firebase project ID

4. **Re-generate service account** (if all else fails):
   - Firebase Console → Project Settings → Service Accounts
   - Click **Generate New Private Key**
   - Download new JSON
   - Grant permissions (steps above)
   - Update GitHub secret `FIREBASE_SERVICE_ACCOUNT_KEY`

### Check Service Account in Firebase Console

1. Firebase Console → Project Settings → Service Accounts
2. Click **Manage service account permissions**
3. Verify your service account has **Firebase App Distribution Admin** role

## Testing Permissions

Run the Firebase test workflow to validate:

```bash
# Locally
flutter test test/firebase_test.dart

# In GitHub Actions
# Go to Actions → Firebase Connection Test → Run workflow
```

The test will check:
- ✅ Service account JSON is valid
- ✅ Required fields present
- ✅ Proper format
- ⚠️  Reminds you to grant permissions

## Quick Fix Script

```bash
#!/bin/bash
# fix-firebase-permissions.sh

# Set your values
PROJECT_ID="your-project-id"
SERVICE_ACCOUNT_JSON="path/to/service-account.json"

# Extract service account email
SERVICE_ACCOUNT_EMAIL=$(jq -r '.client_email' "$SERVICE_ACCOUNT_JSON")

echo "Project: $PROJECT_ID"
echo "Service Account: $SERVICE_ACCOUNT_EMAIL"
echo ""
echo "Granting Firebase App Distribution Admin role..."

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/firebaseappdistro.admin"

echo ""
echo "✅ Permissions granted!"
echo ""
echo "Verifying..."
gcloud projects get-iam-policy "$PROJECT_ID" \
  --flatten="bindings[].members" \
  --filter="bindings.members:serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --format="table(bindings.role)"
```

## Prevention

To avoid this in the future:

1. **Always grant permissions** when creating new service accounts
2. **Use the test workflow** before deploying
3. **Document** which service account is used for CI/CD
4. **Set up alerts** in Google Cloud Console for permission changes

## Summary

**The HTTP 403 error means your service account lacks permissions.**

**Fix**: Grant **Firebase App Distribution Admin** role to your service account.

**Time to fix**: ~2 minutes

**Steps**:
1. Find service account email
2. Go to Google Cloud Console → IAM
3. Add role: Firebase App Distribution Admin
4. Re-run GitHub Actions

After this, your deployments will work! 🚀
