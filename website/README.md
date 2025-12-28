# SeasonBox Landing Page

This directory contains the static landing page for the SeasonBox app. It is designed to be hosted via Firebase Hosting.

## Project Structure

- `index.html`: Main entry point with localized content structure.
- `style.css`: Styling using CSS variables for theming (light/dark mode).
- `script.js`: Logic for language switching and dynamic asset updates.
- `l10n.js`: Localization strings for supported languages (en, de, es, fr, it).
- `assets/`: Images and other static resources.

## CLI Commands

### Prerequisites
Ensure you have the Firebase CLI installed and are logged in:
```bash
npm install -g firebase-tools
firebase login
```

### Run Locally
To test the landing page locally before deploying:

**Option 1: Static Server (Simpler)**
```bash
firebase serve --only hosting
```
Access at: http://localhost:5000

**Option 2: Firebase Emulator (More features)**
```bash
firebase emulators:start --only hosting
```
Access at: http://localhost:5000

### Deploy
To upload and publish the landing page to the live URL:

```bash
firebase deploy --only hosting
```
This will deploy only the contents of `website` as configured in `firebase.json` in the root directory.
