"use strict";

const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const src = path.resolve(root, "..", "flutter_app", "build", "web");
const dst = path.join(root, "hosting");

if (!fs.existsSync(src)) {
  console.error(`Missing Flutter web build: ${src}`);
  console.error("Run: cd flutter_app && flutter build web --release");
  process.exit(1);
}

fs.mkdirSync(dst, { recursive: true });
for (const name of fs.readdirSync(dst)) {
  fs.rmSync(path.join(dst, name), { recursive: true, force: true });
}
fs.cpSync(src, dst, { recursive: true });
console.log(`Synced ${src} -> ${dst}`);
