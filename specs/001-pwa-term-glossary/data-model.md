# Data Model: Glossary (Firebase)

## Entity: GlossaryEntry (logical)

Maps to one term row shown in the UI and one document in Firestore (or one element in the Functions API response).

| Field | Type | Required | Notes |
|-------|------|----------|--------|
| `id` | string | yes | Stable ID (document ID or slug) for keys and analytics |
| `swedish` | string | yes | Source term; **only** this value is copied to clipboard |
| `english` | string | yes | Translation |
| `sortOrder` | int | optional | Stable ordering in the list (default: lexicographic by `swedish` if omitted) |
| `imageStoragePath` | string | optional | Path in Cloud Storage bucket (e.g. `glossary/{id}.webp`); API resolves to URL |
| `createdAt` / `updatedAt` | timestamp | optional | Audit for content management (future) |

### Validation (content rules)

- `swedish`, `english`: non-empty strings after trim for published entries.
- `imageStoragePath`: if present, must reference an object that exists in Storage before publishing (enforced operationally or via admin tooling — not app v1).

### Relationships

- **1:1** between logical entry and one Storage object for the image (optional if image missing — UI shows text-only per edge cases).

## Firestore layout (implementation)

Suggested collection: `glossary_entries/{entryId}`

```text
glossary_entries/{entryId}
  swedish: string
  english: string
  sortOrder: number
  imageStoragePath: string | null
  updatedAt: timestamp
```

Indexes: composite on `sortOrder` + `swedish` if filtering/sorting grows.

## API projection (HTTP Function output)

The client consumes **JSON** shaped like:

```json
{
  "version": 1,
  "updatedAt": "2026-04-03T12:00:00.000Z",
  "entries": [
    {
      "id": "string",
      "swedish": "string",
      "english": "string",
      "imageUrl": "https://..."
    }
  ]
}
```

`imageUrl` may be null if no image — client handles per edge cases.

## State transitions

Read-only for v1: no user-driven state on entities. Future: draft → published workflow in Firestore (out of scope).
