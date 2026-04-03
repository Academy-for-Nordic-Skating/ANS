---
description: "Task list for 001-pwa-term-glossary (Flutter + Firebase)"
---

# Tasks: PWA term glossary (Academy for Nordic Skating)

**Input**: Design documents from `/Users/ward/workspace/ANS/specs/001-pwa-term-glossary/`  
**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md), [research.md](./research.md), [data-model.md](./data-model.md), [contracts/](./contracts/), [quickstart.md](./quickstart.md)

**Tests**: Not requested in the feature specification — no dedicated test tasks. Add widget/integration tests later if the team adopts TDD.

**Organization**: Phases follow user stories P1 (browse) and P2 (copy Swedish term) from `spec.md`.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: User story label ([US1], [US2]) for story phases only
- Paths are absolute under the repository root `/Users/ward/workspace/ANS/`

## Path Conventions (from plan.md)

- Flutter app: `flutter_app/`
- Firebase: `firebase/` (rules, `firebase.json`, `functions/`)

---

## Phase 1: Setup (shared infrastructure)

**Purpose**: Create Flutter app and Firebase project layout per [plan.md](./plan.md).

- [ ] T001 Create Flutter project `flutter_app` with org `se.academyfornordicskating` at `/Users/ward/workspace/ANS/flutter_app/` (`flutter create`)
- [ ] T002 [P] Create Firebase directory layout with `firebase/functions/package.json`, `firebase/functions/tsconfig.json` (TypeScript), and stub `firebase/functions/src/index.ts` at `/Users/ward/workspace/ANS/firebase/`
- [ ] T003 [P] Add `analysis_options.yaml` for the Flutter app at `/Users/ward/workspace/ANS/flutter_app/analysis_options.yaml` (lint rules aligned with Flutter lints)

---

## Phase 2: Foundational (blocking prerequisites)

**Purpose**: Security rules, HTTP glossary API, Flutter bootstrap, and data access — **must complete before User Story 1 UI.**

**⚠️ CRITICAL**: No user story work until this phase completes.

- [ ] T004 [P] Author read-only Firestore rules for `glossary_entries` collection in `/Users/ward/workspace/ANS/firebase/firestore.rules` (no client writes in v1)
- [ ] T005 [P] Author read-only Storage rules for glossary image paths in `/Users/ward/workspace/ANS/firebase/storage.rules` (public read for published assets only)
- [ ] T006 Implement `getGlossary` HTTP function (Firestore query + Storage URL resolution + JSON matching [contracts/glossary-api.openapi.yaml](./contracts/glossary-api.openapi.yaml)) in `/Users/ward/workspace/ANS/firebase/functions/src/index.ts`
- [ ] T007 Complete `/Users/ward/workspace/ANS/firebase/firebase.json` for Cloud Functions (2nd gen), Hosting site, Firestore/Storage emulator bindings, and CORS for the Flutter web origin
- [ ] T008 Add Flutter dependencies (`firebase_core`, `http`, and any `flutterfire` outputs) and generate `firebase_options.dart` via FlutterFire CLI in `/Users/ward/workspace/ANS/flutter_app/`
- [ ] T009 Add `GlossaryEntry` model (fields per [data-model.md](./data-model.md)) in `/Users/ward/workspace/ANS/flutter_app/lib/features/glossary/models/glossary_entry.dart`
- [ ] T010 Implement `GlossaryRepository` to `GET` glossary JSON from the Functions URL and map to `GlossaryEntry` in `/Users/ward/workspace/ANS/flutter_app/lib/features/glossary/glossary_repository.dart`
- [ ] T011 Initialize Firebase and register `MaterialApp` with home route to the glossary feature in `/Users/ward/workspace/ANS/flutter_app/lib/main.dart` and `/Users/ward/workspace/ANS/flutter_app/lib/app.dart`

**Checkpoint**: Emulators can run; HTTP endpoint returns valid JSON; Flutter app starts without runtime errors.

---

## Phase 3: User Story 1 — Browse the term glossary (Priority: P1) 🎯 MVP

**Goal**: Show a scrollable list of terms with Swedish, English, description, and one image per entry; handle empty list and missing/failed images gracefully.

**Independent Test**: Load app with sample glossary data; confirm all four fields render per entry; scroll through multiple entries; long descriptions remain readable (scroll/expand within row).

### Implementation for User Story 1

- [ ] T012 [US1] Build `GlossaryEntryTile` showing Swedish, English, description, and `Image.network` with error/placeholder when `imageUrl` is null or load fails in `/Users/ward/workspace/ANS/flutter_app/lib/features/glossary/glossary_entry_tile.dart`
- [ ] T013 [US1] Build `GlossaryPage` with `ListView` (or `ListView.builder`), pull `GlossaryRepository` via provider pattern or simple constructor injection, and show loading / error / empty states per spec edge cases in `/Users/ward/workspace/ANS/flutter_app/lib/features/glossary/glossary_page.dart`
- [ ] T014 [US1] Ensure long descriptions do not hide meaning: wrap in scrollable or expandable text within the tile in `/Users/ward/workspace/ANS/flutter_app/lib/features/glossary/glossary_entry_tile.dart`

**Checkpoint**: User Story 1 acceptance scenarios from `spec.md` are demonstrable on web without copy feature.

---

## Phase 4: User Story 2 — Copy the Swedish term (Priority: P2)

**Goal**: One clear action copies **only** the Swedish term to the system clipboard; user feedback if copy is blocked.

**Independent Test**: Tap copy on a known term; paste elsewhere — pasted text equals Swedish term exactly (not English or description).

### Implementation for User Story 2

- [ ] T015 [US2] Add explicit copy affordance (e.g. icon button) calling `Clipboard.setData` with `swedish` only in `/Users/ward/workspace/ANS/flutter_app/lib/features/glossary/glossary_entry_tile.dart`
- [ ] T016 [US2] On clipboard failure (e.g. web permission), show a short inline or snackbar message with fallback hint per spec in `/Users/ward/workspace/ANS/flutter_app/lib/features/glossary/glossary_page.dart` or `/Users/ward/workspace/ANS/flutter_app/lib/features/glossary/glossary_entry_tile.dart`

**Checkpoint**: Copy acceptance scenarios from `spec.md` pass on target browsers.

---

## Phase 5: Polish & cross-cutting concerns

**Purpose**: PWA install metadata, Hosting alignment, quickstart validation.

- [ ] T017 [P] Tune PWA metadata (name, theme color, icons) under `/Users/ward/workspace/ANS/flutter_app/web/` including `manifest.json` and favicon references
- [ ] T018 [P] Align Hosting `public` directory with `flutter build web` output path and any SPA rewrites in `/Users/ward/workspace/ANS/firebase/firebase.json`
- [ ] T019 Execute and verify steps in `/Users/ward/workspace/ANS/specs/001-pwa-term-glossary/quickstart.md` (emulators, build, deploy dry-run); fix any doc/code gaps found

---

## Dependencies & execution order

### Phase dependencies

- **Phase 1** → no prerequisites.
- **Phase 2** → depends on Phase 1 (Flutter + Firebase folders exist).
- **Phase 3 (US1)** → depends on Phase 2 (`GlossaryRepository` + models + app shell).
- **Phase 4 (US2)** → depends on Phase 3 (tile/page exist for copy UI).
- **Phase 5** → depends on Phases 3–4 for meaningful validation (can start T017–T018 in parallel with late US2 work if files differ).

### User story dependencies

- **US1**: Starts after Phase 2; no dependency on US2.
- **US2**: Depends on US1 UI components (same tile).

### Within a user story

- US1: T012 (`GlossaryEntryTile`) before T013 (`GlossaryPage` using the tile); T014 extends T012.
- US2: T015 then T016 (same files; sequential).

### Parallel opportunities

| Phase | Parallel tasks |
|-------|----------------|
| 1 | T002, T003 after T001 (or T001 and T002 in parallel — different roots) |
| 2 | T004 and T005 (rules files) |
| 5 | T017 and T018 (web vs firebase.json) |

---

## Parallel example: Phase 2 rules

```text
T004 — Firestore rules in /Users/ward/workspace/ANS/firebase/firestore.rules
T005 — Storage rules in /Users/ward/workspace/ANS/firebase/storage.rules
```

## Parallel example: Phase 5

```text
T017 — PWA assets in /Users/ward/workspace/ANS/flutter_app/web/
T018 — Hosting config in /Users/ward/workspace/ANS/firebase/firebase.json
```

---

## Implementation strategy

### MVP first (User Story 1 only)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (US1).
3. **Stop and validate** against US1 independent test in `spec.md`.
4. Demo or deploy to staging.

### Incremental delivery

1. Setup + Foundational → working API + app shell + repository.
2. US1 → browse glossary with robust empty/image/text handling.
3. US2 → copy Swedish term.
4. Polish → PWA + Hosting + quickstart verification.

### Parallel team strategy

- Developer A: Phase 2 Functions + `firebase.json` (T006–T007).
- Developer B: Phase 2 Flutter model + repository + app (T008–T011) after T006 API shape is agreed from contract.
- Developer C: Phase 1 + rules (T001–T005).
- Converge before US1 UI.

---

## Notes

- Every task includes at least one concrete file path.
- [US1]/[US2] labels only appear in story phases (3–4).
- Seed Firestore/Storage data is implied by T019 / manual steps in `quickstart.md` — add an explicit seed script task only if you introduce one during implementation.
