# SeasonBox

SeasonBox is a mobile application that helps families manage seasonal items (clothes, shoes, gear, boxes, etc.), track which child each item fits, store inventory with photos and storage locations, and receive reminders based on season changes and predicted child growth.

The app solves problems such as:
* Forgetting what is stored where
* Seasonal clothing chaos
* Clothes movement between siblings
* Kids outgrowing items quickly
* Purchasing duplicates due to lack of visibility

## Features
* **User Accounts & Family Sharing**: Google Authentication and family groups to sync data across members.
* **Children Management**: Track children details and size history.
* **Items Management**: Add items with photos, categories, seasons, and sizes.
* **Storage Management**: Organize items in storage locations with optional support for QR codes.
* **Search & Filtering**: Comprehensive search and filtering options for easy item retrieval.
* **Offline Support**: Full offline capabilities with background sync.

## Technology Stack
* **Frontend:** Flutter (Android & iOS)
* **Auth:** Google Authentication (via Firebase Auth)
* **Backend:** Firebase (Firestore, Storage, Functions, Cloud Messaging)
* **Local Storage:** Drift (SQLite) for offline-first support
* **ML (future):** TensorFlow Lite or heuristic growth model
* **Other Integrations:** QR Code generation, image compression

## Documentation
For more detailed information about the project's architecture and permissions, please refer to the documentation in the `docs` folder:

* [Family Architecture](docs/family_architecture.md)
* [PostHog Integration](docs/posthog_integration.md)
* [Deep Link Integration](docs/deeplink_integration.md)
* [Permissions Guide](docs/PERMISSIONS.md): Details on user roles (Admin vs. Member) and access control.
* [Subscription Pricing](docs/subscription_pricing.md): Technical setup and rationale for the subscription system.