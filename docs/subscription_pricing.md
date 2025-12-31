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

The app retrieves Product and Base Plan IDs from Firebase Remote Config.

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
Real-Time Developer Notifications are configured via Google Cloud Pub/Sub (`google-play-subscriptions`). This ensures that cancellations, renewals, and refunds are processed automatically by the `googlePlayBillingWebhook` Cloud Function.
