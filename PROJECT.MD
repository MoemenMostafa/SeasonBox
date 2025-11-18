# SeasonBox —Seasonal Items Mobile App — Project Requirements & Development Plan

## Technology Stack

* **Frontend:** Flutter (Android & iOS)
* **Auth:** Google Authentication (via Firebase Auth)
* **Backend:** Firebase (Firestore, Storage, Functions, Cloud Messaging)
* **Local Storage:** Drift (SQLite) for offline-first support
* **ML (future):** TensorFlow Lite or heuristic growth model
* **Other Integrations:** QR Code generation, image compression

---

# 1. Project Overview

A mobile application that helps families manage seasonal items (clothes, shoes, gear, boxes, etc.), track which child each item fits, store inventory with photos and storage locations, and receive reminders based on season changes and predicted child growth.

The app solves problems such as:

* Forgetting what is stored where
* Seasonal clothing chaos
* Clothes movement between siblings
* Kids outgrowing items quickly
* Purchasing duplicates due to lack of visibility

---

# 2. Key Features (MVP)

## 2.1 User Accounts & Family Sharing

* Google Authentication (Firebase Auth)
* Create or join a family group
* User roles: Admin, Member
* Sync all data across family members

## 2.2 Children Management

* Add child (name, birthdate, gender)
* Track current sizes
* Size history

## 2.3 Items Management

* Add item with:

  * Photo(s)
  * Category
  * Gender (male/female/unisex)
  * Season(s)
  * Size / Size range
  * Storage location
  * Notes
  * Quantity
* Mark status (stored / in use / loaned / donated / sold)
* View item history
* Edit and delete items

## 2.4 Storage Management

* Add storage locations
* Optional hierarchical structure (e.g., Basement → Box 3)
* QR code labels for each box
* Scan QR to view all items inside

## 2.5 Search & Filtering

* Filter by: season, size, child, gender, category, storage location, status
* Full-text search (title, notes)
* Saved filters

## 2.6 Reminders & Notifications

* Seasonal reminders
* Custom item reminders
* Outgrowth prediction reminders (heuristic model for v1)
* Firebase Cloud Messaging for cross-device alerts

## 2.7 Offline Support

* All operations available offline
* Drift (SQLite) local DB
* Background sync with Firestore
* Conflict resolution (last-modified wins)

---

# 3. Phase 2 Features

* Growth prediction model (heuristics → ML later)
* Auto-tagging from item photos
* Marketplace / share or pass-on flow
* Analytics on usage & savings
* Bulk import/export with CSV

---

# 4. Data Model

## 4.1 Item

```
Item {
  id: string,
  familyId: string,
  title: string,
  photos: [url],
  category: string,
  gender: string,
  size: string,
  sizeRange: {min: number, max: number},
  seasonTags: [string],
  storageLocationId: string,
  quantity: number,
  notes: string,
  addedAt: ISODate,
  lastUsedAt: ISODate,
  status: string,
  loanHistory: [{toUserId, fromUserId, date, note}]
}
```

## 4.2 Child

```
Child {
  id: string,
  familyId: string,
  name: string,
  birthdate: ISODate,
  gender: string,
  currentSizeByCategory: {
    "clothes": number,
    "shoes": number
  },
  sizeHistory: [{date, sizeByCategory}]
}
```

## 4.3 StorageLocation

```
StorageLocation {
  id: string,
  familyId: string,
  name: string,
  parentId?: string,
  qrCodeId?: string
}
```

## 4.4 Family

```
Family {
  id: string,
  members: [userId],
  settings: {}
}
```

---

# 5. Screens List

## Onboarding

* Login with Google
* Create/Join Family

## Children

* List children
* Add child
* Edit child
* Size timeline

## Items

* Items dashboard
* Add item (camera/gallery)
* Item detail
* Edit item
* Transfer item

## Storage

* List locations
* Add storage location
* QR code view/print
* Scan QR → Open location

## Search

* Search bar
* Filters
* Saved filters

## Profile & Settings

* Family management
* Notifications settings
* Export / data backup

---

# 6. Firebase Architecture

## Firebase Services Used

* **Authentication** → Google sign-in
* **Firestore** → All structured data
* **Firebase Storage** → Item photos
* **Cloud Functions** → Reminders, cleanup, QR generation (optional)
* **Cloud Messaging** → Push notifications

## Collections

* `/families/{familyId}`
* `/families/{familyId}/items/{itemId}`
* `/families/{familyId}/children/{childId}`
* `/families/{familyId}/locations/{locationId}`
* `/users/{userId}`

---

# 7. Flutter Project Structure

```
lib/
  main.dart
  app/
    theme/
    routes/
  features/
    auth/
    children/
    items/
    storage/
    search/
    reminders/
  data/
    models/
    repositories/
    firebase/
    local_db/
  widgets/
  utils/
```

---

# 8. Development Plan (Sprint Outline)

## Sprint 1 — Foundation

* Flutter project setup
* Firebase initialization
* Google Auth integration
* App theme + routing
* Local DB setup (Drift)

## Sprint 2 — Core Data

* Data models
* Firestore sync architecture
* Add child flow
* Add storage location
* Add item (without photo upload)

## Sprint 3 — Media & Storage

* Photo capture + compression
* Firebase Storage integration
* Offline thumbnails
* Storage box QR codes

## Sprint 4 — Search & Filters

* Items list + filtering
* Search bar
* Saved filters

## Sprint 5 — Reminders

* Local notifications
* Seasonal reminders
* Growth prediction heuristic
* Cloud Messaging

## Sprint 6 — Polish + Sharing

* Family sharing flows
* Transfer item
* Basic analytics
* QA, bugfixing, release preparation

---

# 9. Notes for Firebase Studio

* Project uses Firestore hierarchical schema with family-level subcollections
* Requires Firebase Auth with Google provider
* Firestore rules must enforce family ownership on all documents
* Requires Cloud Messaging and optional Cloud Functions
* Collections will be auto-generated when used from Flutter

---

# 10. Ready for import

This file contains:

* Full project description
* Data structures
* Architecture plan
* Firebase collections
* Screens list
* Development roadmap

It is formatted for compatibility with Firebase Studio and Copilot agents.
