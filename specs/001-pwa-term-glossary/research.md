# Research: 001-pwa-term-glossary

## 1. Flutter for PWA + “installable” behavior

**Decision**: Use **Flutter web** as the primary target; build with `flutter build web`, deploy to **Firebase Hosting**, and enable PWA characteristics via Flutter’s web support (service worker, web manifest). Validate “add to home screen” on Chrome/Android and Safari/iOS.

**Rationale**: One codebase matches the user’s Flutter choice; web build satisfies the spec’s PWA intent (installable/addable where supported). Mobile apps can reuse the same code later.

**Alternatives considered**:

- **Separate React/Vue PWA**: Rejected — user explicitly chose Flutter.
- **Flutter mobile-only**: Rejected — spec emphasizes PWA/web-class delivery.

## 2. Firebase data split: Firestore + Storage

**Decision**: Store **text fields** (`swedish`, `english`, ordering metadata) in **Firestore**. Store **image bytes** in **Cloud Storage**; Firestore holds `imagePath` or stable reference; the API returns ready-to-use **HTTPS URLs** (public read with locked-down write, or short-lived signed URLs from Functions).

**Rationale**: Keeps documents small and fast to query; images scale independently; matches “one picture per term.”

**Alternatives considered**:

- **Base64 images in Firestore**: Rejected — size/cost limits and poor caching.
- **External CDN URLs only**: Possible for v1 if Academy hosts images elsewhere; Firestore would store absolute URL strings instead of Storage paths.

## 3. Cloud Functions role

**Decision**: Implement an **HTTP GET** Cloud Function (2nd gen) that returns a **JSON list** of glossary entries with **image URLs** resolved server-side. The Flutter app fetches this endpoint (CORS enabled for Hosting origin). Optionally cache responses with `Cache-Control` for static snapshots if content changes infrequently.

**Rationale**: Satisfies “Firebase with Cloud Functions”; centralizes field shaping; simplifies client; allows future admin-only writes without exposing complex rules to anonymous clients for writes.

**Alternatives considered**:

- **Direct Firestore reads from Flutter only**: Simpler and valid for read-only public data; **rejected as primary** for this plan because the user asked for Cloud Functions — keep Functions as the public read API for v1, with optional Firestore SDK later for offline cache if needed.
- **Callable functions**: Possible; HTTP GET is simpler for cacheability and non-Flutter clients.

## 4. Clipboard (Swedish term only)

**Decision**: Use Flutter **`Clipboard.setData`** with **only** the `swedish` string on the copy action; separate UI control from English.

**Rationale**: Matches FR-005 (Swedish only); works on web and mobile from same API.

## 5. Testing strategy

**Decision**: **Firebase Emulator Suite** for Firestore/Storage/Functions in local dev and CI; widget tests for list/empty/copy; contract test against OpenAPI for HTTP response shape.

**Rationale**: Reproducible tests without touching production; fast feedback.

## 6. Auth scope

**Decision**: **No authentication** for public glossary read in v1, consistent with spec assumptions.

**Rationale**: FR-002; reduces scope. Revisit when CMS or editing is added.
