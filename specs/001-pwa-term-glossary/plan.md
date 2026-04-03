# Implementation Plan: PWA term glossary (Academy for Nordic Skating)

**Branch**: `001-pwa-term-glossary` | **Date**: 2026-04-03 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `/specs/001-pwa-term-glossary/spec.md`  
**Stack input**: Flutter for the app; Firebase (Firestore, Storage, Hosting) with Cloud Functions.

## Summary

Deliver a cross-platform **Flutter** client (web-first for PWA install/add-to-home-screen) that lists Nordic skating glossary entries (Swedish, English, one image) and copies the Swedish term via the clipboard. **Firebase** holds curated content: **Cloud Firestore** for text fields and image references, **Cloud Storage** for image files, **Cloud Functions** for a read-only HTTP API that returns a versioned glossary payload the app consumes (keeps the client thin, centralizes shaping/signed URLs, and leaves room for caching and future non-client admin flows). **Firebase Hosting** serves the built Flutter web app.

## Technical Context

**Language/Version**: Dart (SDK version pinned by Flutter); Flutter stable channel (exact version locked in `pubspec`/CI)  
**Primary Dependencies**: Flutter SDK; `firebase_core`, `cloud_firestore` (optional cache/offline), `firebase_storage` (if resolving refs client-side), `cloud_functions` or `http` client for Functions HTTP API; `flutter/services` (`Clipboard`); PWA: `flutter build web` with web manifest + service worker  
**Storage**: Cloud Firestore (glossary documents), Cloud Storage (images), Firebase security rules for both  
**Testing**: `flutter_test` (unit/widget), `integration_test` (web/mobile smoke), Firebase Emulator Suite for Firestore/Storage/Functions in CI/local  
**Target Platform**: Web (PWA) primary; iOS/Android from same Flutter codebase as stretch or parallel track  
**Project Type**: cross-platform Flutter application with Firebase backend (BaaS) and Cloud Functions (Node.js or Python per team choice)  
**Performance Goals**: Smooth scrolling for hundreds of entries on mid-range phones; images loaded lazily; first contentful glossary data under typical 4G conditions without blocking UI  
**Constraints**: Read-only public glossary for v1 (no auth); clipboard must copy Swedish term only; graceful empty/error states per spec  
**Scale/Scope**: Curated list (order tens to low thousands of entries); single region Firebase project acceptable initially  

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The project [constitution](../../.specify/memory/constitution.md) is still a template (no ratified principles). **Default gates applied for this plan:**

| Gate | Status |
|------|--------|
| Alignment with feature spec (read-only glossary, PWA intent, copy behavior) | Pass |
| Security: public read paths only where intended; no accidental write exposure | Pass (rules + API design) |
| Testability: core parsing and API contract testable without production Firebase | Pass (emulators + contract tests) |

**Post-design**: Architecture stays within Flutter + Firebase; Functions justify a single public read surface; no extra services added.

## Project Structure

### Documentation (this feature)

```text
specs/001-pwa-term-glossary/
├── plan.md              # This file
├── research.md          # Phase 0
├── data-model.md        # Phase 1
├── quickstart.md        # Phase 1
├── contracts/           # Phase 1
└── tasks.md             # Phase 2 (/speckit.tasks — not created here)
```

### Source Code (repository root)

```text
flutter_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── features/
│   │   └── glossary/
│   │       ├── glossary_page.dart
│   │       ├── glossary_entry_tile.dart
│   │       └── glossary_repository.dart
│   └── core/
│       ├── firebase/
│       └── clipboard/
├── web/
│   ├── index.html
│   └── manifest.json    # PWA metadata (may be generated/adjusted for Flutter web)
├── test/
├── integration_test/
└── pubspec.yaml

firebase/
├── firebase.json
├── firestore.rules
├── storage.rules
└── functions/
    ├── package.json
    ├── tsconfig.json    # if TypeScript
    └── src/
        └── index.ts     # HTTP glossary function + exports
```

**Structure Decision**: Single Flutter app under `flutter_app/` plus `firebase/` for rules and Cloud Functions. Hosting rewrites or multiple sites can map `/` to Flutter web build output in `firebase.json` during CI.

## Complexity Tracking

> No constitution violations requiring justification. Firebase + Flutter + Functions is the requested stack; Functions avoid exposing raw Firestore shape to the client and keep one place for future moderation or aggregation.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| — | — | — |
