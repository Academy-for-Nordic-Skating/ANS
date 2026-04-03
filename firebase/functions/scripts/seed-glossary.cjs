#!/usr/bin/env node
/**
 * Seeds `glossary_entries` with sample Nordic skating terms.
 *
 * **Firestore emulator (default):** start emulators first, then:
 *   cd firebase/functions && npm run seed:glossary
 *
 * **Real project:** unset FIRESTORE_EMULATOR_HOST and use Application Default Credentials
 *   (e.g. `gcloud auth application-default login`).
 */
const { initializeApp, getApps } = require("firebase-admin/app");
const { getFirestore, Timestamp } = require("firebase-admin/firestore");

let projectId = process.env.GCLOUD_PROJECT || process.env.GCP_PROJECT;
if (!projectId && process.env.FIREBASE_CONFIG) {
  try {
    projectId = JSON.parse(process.env.FIREBASE_CONFIG).projectId;
  } catch (_) {
    /* ignore */
  }
}
projectId = projectId || "ans-glossary-local";

if (!process.env.FIRESTORE_EMULATOR_HOST) {
  process.env.FIRESTORE_EMULATOR_HOST = "127.0.0.1:8080";
}

if (getApps().length === 0) {
  initializeApp({ projectId });
}

const db = getFirestore();

/** @type {Array<{id: string, swedish: string, english: string, sortOrder: number, imageStoragePath?: string | null}>} */
const entries = [
  {
    id: "langfardsskridsko",
    sortOrder: 1,
    swedish: "Långfärdsskridsko",
    english: "Tour skating / long-distance skating",
    imageStoragePath: null,
  },
  {
    id: "isskar",
    sortOrder: 2,
    swedish: "Isskär",
    english: "Ice edge / rim ice",
    imageStoragePath: null,
  },
  {
    id: "isvak",
    sortOrder: 3,
    swedish: "Isvak",
    english: "Open water / hole in the ice",
    imageStoragePath: null,
  },
  {
    id: "sjois",
    sortOrder: 4,
    swedish: "Sjöis",
    english: "Lake ice",
    imageStoragePath: null,
  },
  {
    id: "pulk",
    sortOrder: 5,
    swedish: "Pulk",
    english: "Sled / pulk",
    imageStoragePath: null,
  },
];

async function main() {
  const batch = db.batch();
  const now = Timestamp.now();
  for (const e of entries) {
    const ref = db.collection("glossary_entries").doc(e.id);
    batch.set(ref, {
      swedish: e.swedish,
      english: e.english,
      sortOrder: e.sortOrder,
      imageStoragePath: e.imageStoragePath ?? null,
      updatedAt: now,
    });
  }
  await batch.commit();
  console.log(
    `Seeded ${entries.length} documents into glossary_entries (project: ${projectId}, Firestore: ${process.env.FIRESTORE_EMULATOR_HOST || "production"})`,
  );
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
