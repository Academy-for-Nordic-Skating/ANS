#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/../flutter_app/build/web"
DST="$ROOT/hosting"
if [[ ! -d "$SRC" ]]; then
  echo "Missing Flutter web build: $SRC" >&2
  echo "Run: cd \"\$(git rev-parse --show-toplevel 2>/dev/null || echo ..)/flutter_app\" && flutter build web --release" >&2
  exit 1
fi
mkdir -p "$DST"
rsync -a --delete "$SRC/" "$DST/"
