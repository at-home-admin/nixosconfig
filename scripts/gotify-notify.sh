#!/usr/bin/env bash
set -euo pipefail

# Set these in the script or pass via env from systemd
GOTIFY_URL="${GOTIFY_URL:?Missing GOTIFY_URL}"
GOTIFY_TOKEN="${GOTIFY_TOKEN:?Missing GOTIFY_TOKEN}"
APP_TOKEN="${APP_TOKEN:-}"   # optional

TITLE="${TITLE:-NixOS update}"
MESSAGE="${MESSAGE:-NixOS autoupdate finished}"

# Send notification
curl -sS -X POST \
  -H "X-Gotify-Token: ${GOTIFY_TOKEN}" \
  -F "title=${TITLE}" \
  -F "message=${MESSAGE}" \
  "${GOTIFY_URL}/message" >/dev/null
