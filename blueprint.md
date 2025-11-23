# SeasonBox Blueprint

## Overview

SeasonBox is a mobile application that helps families manage seasonal items (clothes, shoes, gear, boxes, etc.), track which child each item fits, store inventory with photos and storage locations, and receive reminders based on season changes and predicted child growth.

## Style and Design

The app uses the Material Design 3 theme with a custom color scheme and the Lato font. It has both light and dark modes.

*   **Primary Color:** #6200EE
*   **Secondary Color:** #03DAC6
*   **Font:** Lato (from google_fonts)

## Features

*   **User Accounts & Family Sharing:** Google Authentication, family groups, user roles.
*   **Children Management:** Track children, sizes, and size history.
*   **Items Management:** Add items with photos, categories, seasons, sizes, and storage locations.
*   **Storage Management:** Manage storage locations and QR codes.
*   **Search & Filtering:** Filter items by various criteria.
*   **Reminders & Notifications:** Seasonal reminders, outgrowth predictions.
*   **Offline Support:** Drift (SQLite) local DB with Firestore sync.

## Current Plan

*   **Sprint 1 — Foundation:**
    *   [x] Flutter project setup
    *   [x] Firebase initialization
    *   [x] Google Auth integration
    *   [x] App theme + routing
    *   [x] Local DB setup (Drift)
*   **Sprint 2 — Core Data:**
    *   [ ] Data models
    *   [ ] Firestore sync architecture
    *   [ ] Add child flow
    *   [ ] Add storage location
    *   [ ] Add item (without photo upload)
