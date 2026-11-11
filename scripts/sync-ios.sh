#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

cp app/index.html ios/LiteLedger/index.html
echo "Synced app/index.html -> ios/LiteLedger/index.html"
