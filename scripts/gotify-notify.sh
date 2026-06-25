#!/usr/bin/env bash
set -euo pipefail

GOTIFY_URL="https://notification.athomeadmin.net" # <- change
GOTIFY_TOKEN="ACeTrqPOxl6UTnA"                    # <- change

TEXT_OK="NixOS auto-upgrade: SUCCESS"
TEXT_FAIL="NixOS auto-upgrade: FAILED"

# Optional: if you want the host name in the message
HOST="$(hostname -s 2>/dev/null || hostname)"

# Expect: script is called with exit code as $1
# Usage: autoupdate-gotify.sh 0   (success)
#        autoupdate-gotify.sh 1   (failure)
RC="${1:-1}"

if [ "$RC" -eq 0 ]; then
  TITLE="$TEXT_OK"
else
  TITLE="$TEXT_FAIL"
fi

# Gotify supports JSON with title/message fields (adjust if your instance differs)
PAYLOAD="$(jq -nc --arg title "$TITLE" --arg msg "Host: $HOST" '{title:$title, message:$msg}')"

# If you don't have jq, replace PAYLOAD creation with a literal JSON string.
# Example without jq:
# PAYLOAD="{\"title\":\"$TITLE\",\"message\":\"Host: $HOST\"}"

curl -fsS \
  -H "X-Gotify-Token: ${GOTIFY_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  "$GOTIFY_URL" >/dev/null
