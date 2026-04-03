# Quickstart: Flutter + Firebase (001-pwa-term-glossary)

## Prerequisites

- Flutter SDK (stable), Chrome for web testing
- Node.js LTS (for Firebase CLI and Cloud Functions)
- Firebase CLI (`npm install -g firebase-tools`) logged in (`firebase login`)

## 1. Create the Flutter app (if not present)

```bash
cd /Users/ward/workspace/ANS
flutter create --org se.academyfornordicskating flutter_app
cd flutter_app
flutter pub add firebase_core http
```

Add Firebase to Flutter per [FlutterFire](https://firebase.google.com/docs/flutter/setup) (`flutterfire configure`) to generate `firebase_options.dart` for the correct platforms (at minimum **web**).

## 2. Initialize Firebase in the repo

```bash
cd /Users/ward/workspace/ANS
firebase init
```

Select: **Firestore**, **Storage**, **Functions** (TypeScript or JavaScript), **Hosting** (public directory will point to `flutter_app/build/web` after build).

Place configuration under `firebase/` as described in [plan.md](./plan.md) or keep default `.` layout — align `firebase.json` with the chosen folder structure.

## 3. Local development with emulators

```bash
cd /Users/ward/workspace/ANS
firebase emulators:start
```

Point the Flutter app at emulator hosts for Firestore/Functions when testing integrated flows (see FlutterFire emulator docs).

## 4. Build web + deploy

```bash
cd /Users/ward/workspace/ANS/flutter_app
flutter build web --release
cd ..
firebase deploy --only hosting,functions
```

Verify PWA install/add-to-home-screen on a real device and run through spec acceptance scenarios (list, image fallback, copy Swedish only).

## 5. Seed data (development)

Use Firebase console or a one-off admin script to create documents in `glossary_entries` and upload images to Storage under agreed paths; then hit the `getGlossary` HTTP function to confirm JSON matches [contracts/glossary-api.openapi.yaml](./contracts/glossary-api.openapi.yaml).
