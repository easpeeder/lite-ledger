#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

rm -rf android/app/src/main/assets
mkdir -p android/app/src/main/assets
cp app/index.html app/manifest.webmanifest app/sw.js app/icon-192.png app/icon-512.png android/app/src/main/assets/

echo "Synced app/ -> android/app/src/main/assets/"
