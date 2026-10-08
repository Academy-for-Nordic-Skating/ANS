import { initializeApp } from "firebase-admin/app";
import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

initializeApp();

const db = getFirestore();

interface GlossaryDoc {
  swedish: string;
  english: string;
  sortOrder?: number;
  imageStoragePath?: string | null;
  updatedAt?: Timestamp;
}

export const getGlossary = onRequest(
  {
    cors: true,
    region: "europe-west1",
    memory: "256MiB",
  },
  async (req, res) => {
    if (req.method === "OPTIONS") {
      res.status(204).send("");
      return;
    }
    if (req.method !== "GET") {
      res.status(405).json({ error: "Method Not Allowed" });
      return;
    }

    try {
      const snapshot = await db.collection("glossary_entries").get();
      const bucket = getStorage().bucket();

      type Row = {
        id: string;
        data: GlossaryDoc;
      };

      const rows: Row[] = snapshot.docs.map((doc) => ({
        id: doc.id,
        data: doc.data() as GlossaryDoc,
      }));

      rows.sort((a, b) => {
        const ao = a.data.sortOrder ?? 1_000_000;
        const bo = b.data.sortOrder ?? 1_000_000;
        if (ao !== bo) {
          return ao - bo;
        }
        const sa = a.data.swedish ?? "";
        const sb = b.data.swedish ?? "";
        return sa.localeCompare(sb, "sv");
      });

      let maxUpdated: Timestamp | null = null;
      const entries: Array<{
        id: string;
        swedish: string;
        english: string;
        imageUrl: string | null;
      }> = [];

      for (const row of rows) {
        const d = row.data;
        if (d.updatedAt && (!maxUpdated || d.updatedAt.toMillis() > maxUpdated.toMillis())) {
          maxUpdated = d.updatedAt;
        }

        // Public download URL (storage.rules allow read for glossary/**). Avoids
        // getSignedUrl IAM failures that left imageUrl null and broke the client UI.
        // Append &v=<updatedAt> so browsers/PWAs fetch a new image after CMS replaces
        // a file at the same Storage path (same path alone is cached forever otherwise).
        let imageUrl: string | null = null;
        const path = d.imageStoragePath?.trim();
        if (path) {
          const enc = encodeURIComponent(path);
          const version = d.updatedAt ? d.updatedAt.toMillis() : 0;
          imageUrl =
            `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${enc}` +
            `?alt=media&v=${version}`;
        }

        entries.push({
          id: row.id,
          swedish: d.swedish ?? "",
          english: d.english ?? "",
          imageUrl,
        });
      }

      const body = {
        version: 1,
        updatedAt: maxUpdated ? maxUpdated.toDate().toISOString() : null,
        entries,
      };

      // Avoid stale lists after CMS edits (Flutter web uses the browser HTTP cache).
      res.set("Cache-Control", "no-store");
      res.status(200).json(body);
    } catch (e) {
      logger.error("getGlossary failed", e);
      res.status(500).json({ error: "Internal Server Error" });
    }
  }
);
