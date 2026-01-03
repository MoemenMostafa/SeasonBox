# Subscription Pricing & Platform Configuration

This document outlines the subscription setup for SeasonBox on Google Play.

## Google Play Console Configuration

The app uses a **single Product ID** with **multiple Base Plans** (standard Billing 5+ structure).

- **Product ID:** `premium`
- **Base Plan IDs:**
    - `monthly`: Auto-renewing monthly subscription.
    - `yearly`: Auto-renewing yearly subscription (usually with a discount).

### Setup Steps in Play Console
1. Navigate to **Monetize > Products > Subscriptions**.
2. Create a subscription with ID `premium`.
3. Add a **Base Plan** with ID `monthly`. Set it to "Auto-renew" and specify the monthly price.
4. Add a **Base Plan** with ID `yearly`. Set it to "Auto-renew" and specify the yearly price.
5. Ensure both base plans are **Active**.

## App Configuration (Remote Config)

The app retrieves Product and Base Plan IDs from Firebase Remote Config. This decouples the **Marketing Layer** (UI and product selection) from the **Transaction Layer** (Google Play), providing several benefits:

- **Bypass App Store Reviews:** Update UI, descriptions, and plan visibility instantly without a new release.
- **A/B Testing:** Experiment with different pricing structures or promotional text to optimize conversions.
- **Targeted Offerings:** Show specific plans or discounts based on user behavior or segments via Remote Config conditions.
- **Emergency Control:** Use as a "kill switch" to hide plans or features if bugs are discovered in production.
- **Marketing Flexibility:** Easily add "Best Value" badges or change the order of plans without changing code.

| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| `subscription_product_ids` | `{"monthly": "premium", "yearly": "premium"}` | Maps billing cycles to Play Store Product IDs. |
| `subscription_base_plan_ids` | `{"monthly": "monthly", "yearly": "yearly"}` | Maps billing cycles to Base Plan IDs within the product. |
| `subscription_pricing` | `{"monthly": "2.99", "yearly": "19.99"}` | Fallback display prices (the app prefers live Play Store prices). |

## Technical Implementation Details

### Purchase Flow
The `SubscriptionService` uses the `in_app_purchase` package. When a user selects a plan:
1. The app queries `premium` product details.
2. It searches the `subscriptionOfferDetails` for an offer matching the `basePlanId` (`monthly` or `yearly`).
3. It initiates the purchase using `GooglePlayPurchaseParam` with the selected product.

### Verification
Purchases are verified server-side via a Cloud Function (`verifyPurchase`). This function:
1. Uses the `google-play-billing` secret (Service Account JSON).
2. Validates the purchase token with the Google Play Developer API.
3. Updates the user's `subscriptionTier` to `paid` and sets `subscriptionExpiry` in Firestore.

## Webhooks (RTDN)

Real-Time Developer Notifications (RTDN) allow Google Play to proactively notify our backend about state changes.

### Connection Architecture
1. **Pub/Sub Topic:** `play-billing-events`. This topic receives Base64 encoded notifications from Google Play.
2. **Cloud Function:** `googlePlayBillingWebhook` (v2) listens to this topic.
3. **Google Play Console Link:**
    - Navigate to **Monetization setup > Real-time developer notifications**.
    - Topic name: `projects/seasonbox-747d6/topics/play-billing-events`.
    - Click **Send Test Message** to verify the link.
4. **Permissions:** The Google Play service account (`google-play-billing-any@system.gserviceaccount.com`) must have the **Pub/Sub Publisher** role on the topic.

### Handling Logic
When a notification arrives:
1. The webhook decodes the data.
2. It uses a service account (stored in `playConfig` secret) to fetch the full transaction details from the Play Developer API.
3. It identifies the user via `activePurchaseToken` stored in Firestore.
4. It updates the user's `subscriptionTier` and `subscriptionExpiry`.

## Robustness & Retry Logic

The `SubscriptionService` includes a built-in retry mechanism for initialization. If the connection to the Google Play Store fails:
- It automatically retries **up to 2 times** with a 2-second delay between attempts.
- It logs the `subscription_store_available` event to PostHog with the number of attempts and availability state.
- It exposes a `reInitialize()` method for manual retries from the UI.

## Diagnostic Tools

The `SubscriptionScreen` provides several diagnostic features to help troubleshoot store issues in production:

1. **Error Banner:** If the store is unavailable, a prominent red banner appears at the top of the screen displaying the `lastError` message and a **Retry Connection** button.
2. **Diagnostic SnackBar:** If a product selection fails, a SnackBar appears with detailed technical information:
    - Store availability state.
    - Count of loaded products.
    - The ID of the product that failed to load.
    - List of currently loaded Product IDs.
    - Debug mode status.
    - The last recorded initialization error.

## Platform Specifics (Android 11+)

To ensure the In-App Purchase plugin works correctly on Android 11+ (API level 30+), the following configurations are maintained in `AndroidManifest.xml`:

- **Permissions:** `<uses-permission android:name="com.android.vending.BILLING" />` is required for billing operations.
- **Package Visibility:** A `<queries>` section is used to allow the app to interact with the Play Store billing service:
  ```xml
  <queries>
      <intent>
          <action android:name="com.android.vending.billing.InAppBillingService.BIND" />
      </intent>
  </queries>
  ```
