# Quickstart: Flutter + Firebase (001-pwa-term-glossary)

Verified against the repository layout: configuration lives under `firebase/`; the Flutter app is `flutter_app/`.

## Prerequisites

- Flutter SDK (stable), Chrome for web testing
- Node.js (for Cloud Functions build; Node 20 recommended to match `firebase/functions/package.json`)
- Firebase CLI (`npm install -g firebase-tools`) and `firebase login`

## 1. Install dependencies

```bash
cd /Users/ward/workspace/ANS/flutter_app
flutter pub get

cd /Users/ward/workspace/ANS/firebase/functions
npm install
npm run build
```

## 2. FlutterFire (replace placeholder config)

The template file `flutter_app/lib/firebase_options.dart` uses placeholder values. Generate real options:

```bash
dart pub global activate flutterfire_cli
cd /Users/ward/workspace/ANS/flutter_app
dart pub global run flutterfire_cli:flutterfire configure --platforms=web,ios,android
```

Link the Firebase project to `.firebaserc` (or align `ans-glossary-local` with your project ID).

## 3. Local emulators (Functions + Firestore + Storage + Hosting UI)

From the **`firebase/`** directory (where `firebase.json` lives):

```bash
cd /Users/ward/workspace/ANS/firebase
firebase emulators:start
```

**Important:** The Flutter app loads terms through the **`getGlossary` HTTP function**, not the Firestore SDK. Seeding the **Firestore emulator** is correct, but you must also run the **Functions emulator** (included in the command above) so `http://127.0.0.1:5001/.../getGlossary` returns data. If you only start the Firestore emulator, the app will show an error or an empty list.

After startup, the **Hosting** emulator serves the built web app at **`http://127.0.0.1:5050`** (port **5050** is set in `firebase/firebase.json` because **5000** is often taken on macOS, e.g. by **AirPlay Receiver**).

The HTTP function is available at:

`http://127.0.0.1:5001/ans-glossary-local/europe-west1/getGlossary`

The Flutter app defaults to that URL via `GLOSSARY_URL` (see `glossary_repository.dart`). Override if your project ID or region differs:

```bash
cd /Users/ward/workspace/ANS/flutter_app
flutter run -d chrome \
  --dart-define=GLOSSARY_URL=http://127.0.0.1:5001/ans-glossary-local/europe-west1/getGlossary
```

## 4. Seed sample data (Firestore + optional Storage)

**Script (recommended):** with emulators running (or Firestore emulator only), in another terminal:

```bash
cd /Users/ward/workspace/ANS/firebase/functions
npm run seed:glossary
```

This writes five sample documents to `glossary_entries` (Swedish, English, `sortOrder`, no images). The script targets the **Firestore emulator** at `127.0.0.1:8080` by default (`FIRESTORE_EMULATOR_HOST`). If you change the Firestore emulator port in `firebase.json`, set the same host/port in the environment.

**Manual:** In the **Firestore emulator** (port 8080 in `firebase.json`), create collection `glossary_entries` with documents such as:

| Field | Type | Example |
|-------|------|---------|
| `swedish` | string | `Långfärdsskridsko` |
| `english` | string | `Tour skating` |
| `sortOrder` | number | `1` |
| `imageStoragePath` | string or null | `glossary/sample.png` or null |
| `updatedAt` | timestamp | (optional) |

If `imageStoragePath` is set, upload the file to the **Storage emulator** under `glossary/...` so Admin can sign a URL.

Then open the app and pull to refresh or use the app bar **Refresh** action.

## 5. Build web + deploy

```bash
cd /Users/ward/workspace/ANS/flutter_app
flutter build web --release

cd /Users/ward/workspace/ANS/firebase
firebase deploy --only hosting,functions,firestore,storage
```

Hosting serves `../flutter_app/build/web` per `firebase.json`. Set production glossary URL at build time:

```bash
flutter build web --release \
  --dart-define=GLOSSARY_URL=https://europe-west1-<YOUR_PROJECT_ID>.cloudfunctions.net/getGlossary
```

## 6. Acceptance checks

- List shows Swedish, English, and image (or placeholder).
- Empty state when `entries` is `[]`.
- Copy button copies **Swedish only**; snackbar on success; fallback message if copy fails.
- PWA: install/add to home screen from Hosting URL (after deploy).

## 7. Troubleshooting

- **`Could not start Hosting Emulator, port taken` (often port 5000):** This repo uses Hosting emulator port **5050** in `firebase/firebase.json`. If **5050** is also busy, change `"emulators.hosting.port"` to another free port (e.g. `5055`) and use that URL instead.
- **`Unable to look up project number for …` / extensions warnings:** For **emulator-only** work without a real Firebase project, you can set the default project in `firebase/.firebaserc` to an ID starting with **`demo-`** (e.g. `demo-ans-glossary`) and update the `GLOSSARY_URL` path segment to match. Otherwise the CLI may still run; warnings are often safe to ignore locally.

API shape: [contracts/glossary-api.openapi.yaml](./contracts/glossary-api.openapi.yaml).
