# Feature Specification: PWA term glossary (Academy for Nordic Skating)

**Feature Branch**: `001-pwa-term-glossary`  
**Created**: 2026-04-03  
**Status**: Draft  
**Input**: User description: "We want to build a Progressive Web App for the Academy for Nordic Skating. The first use case is showing a list of Swedish terms and their English translation and one picture. It should be easy for the user to copy the term to their clipboard."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Browse the term glossary (Priority: P1)

A learner or instructor opens the app to see a list of Nordic skating terms. Each entry shows the Swedish term, its English equivalent, and one illustrative image so they can learn vocabulary in context.

**Why this priority**: This is the stated first use case and delivers the core reference value for the Academy’s audience.

**Independent Test**: Can be fully tested by loading the app with sample content and confirming every listed term displays Swedish text, English text, and one image without requiring copy or other features.

**Acceptance Scenarios**:

1. **Given** the app has at least one glossary entry, **When** the user opens the app, **Then** they see a list (or equivalent scannable layout) of terms with Swedish, English, and one image visible for each entry.
2. **Given** multiple terms exist, **When** the user scrolls through the list, **Then** they can reach every term and see all three elements for each without leaving the main browsing flow.
3. **Given** Swedish or English text of typical length, **When** the user views that entry, **Then** both lines remain readable (not truncated in a way that hides required meaning without a way to see the rest).

---

### User Story 2 - Copy the Swedish term (Priority: P2)

A user who needs the Swedish wording elsewhere (messages, notes, or instruction) copies the Swedish term to their device clipboard with minimal steps.

**Why this priority**: Explicitly requested; supports reuse of vocabulary outside the app but depends on terms being visible (P1).

**Independent Test**: Can be fully tested by selecting copy for a known term and pasting into another app or field to verify the clipboard contains exactly the Swedish term string.

**Acceptance Scenarios**:

1. **Given** a term is visible in the list or detail view, **When** the user uses the copy affordance for that term, **Then** the Swedish term text is placed on the clipboard.
2. **Given** the user has just copied a term, **When** they paste elsewhere, **Then** the pasted content matches the displayed Swedish term (no accidental extra words from the English line or image).

---

### Edge Cases

- No terms available: the user sees a clear, friendly empty state (not a blank or broken screen).
- Image missing or failing to load: the user still sees Swedish and English; the absence of the image is handled gracefully (e.g., placeholder or compact omission without breaking layout).
- Very long Swedish or English text: content remains readable (e.g., wrapping or scroll within the entry) without losing access to copy or other fields.
- Copy when the environment restricts clipboard access: the user gets a clear message and, where possible, a fallback (e.g., select-and-copy instructions).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The product MUST present a glossary of Nordic skating terms relevant to the Academy’s domain, each including Swedish text, English translation, and one associated image.
- **FR-002**: The user MUST be able to browse all entries from a single primary flow (list or list-plus-detail) without needing an account for this first use case.
- **FR-003**: For each entry, Swedish, English, and image MUST be discernible in the interface when that content exists (image may be absent with a clear placeholder per edge cases).
- **FR-004**: The user MUST be able to copy the Swedish term string to the clipboard through a dedicated, easy-to-discover action (e.g., one tap or click from the entry, or an explicit “Copy Swedish term” control).
- **FR-005**: Copied content MUST be the Swedish term only, not the English line or image.
- **FR-006**: The experience MUST meet the intent of a Progressive Web App: users can add the glossary to their device home screen or app launcher where the device allows, open it from there like other apps, and still use the same experience when opening it without installing.
- **FR-007**: Layout MUST remain usable on common phone and desktop screen sizes for reading and copying.

### Key Entities *(include if feature involves data)*

- **Glossary entry**: One vocabulary item for Nordic skating: Swedish term (source label), English translation, and one illustrative image associated with that item.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In usability testing or acceptance checks, at least 90% of participants complete “find a term and confirm Swedish, English, and image” for a sample list without assistance.
- **SC-002**: Copying the Swedish term succeeds in under 10 seconds from an entry being on screen, for users who use the provided copy action (median task time in structured tests).
- **SC-003**: On devices that support it, users can add the glossary to their home screen or app list and open it from there; doing so opens the glossary experience without requiring them to navigate from scratch each time.
- **SC-004**: No more than one critical usability defect (e.g., unreadable text, broken copy, missing empty state) remains open at release for this feature scope.

## Assumptions

- Content (terms, translations, images) is provided and maintained by the Academy; this specification does not include authoring or CMS workflows unless added later.
- The first release focuses on read-only glossary and copy; user accounts, editing, search, and multiple languages beyond Swedish/English are out of scope unless follow-on features are specified.
- “One picture” means one image asset per glossary entry, supplied with the content; animated or multiple images per term are out of scope for this feature.
- Target users have devices and browsers that support standard web apps and clipboard access; older or restricted environments receive clear messaging when something is unsupported.
