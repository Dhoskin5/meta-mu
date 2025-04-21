#!/bin/sh

TAG="mu-init"
UPDATE_INBOX_DIR="${UPDATE_INBOX_DIR:-/data/update-inbox}"
MANIFEST_FILE="$UPDATE_INBOX_DIR/manifest.json"

echo "mu-init: Checking for manifest in $UPDATE_INBOX_DIR" | systemd-cat -t $TAG

if [ -f "$MANIFEST_FILE" ]; then
    echo "mu-init: Found manifest, triggering mu-verify" | systemd-cat -t $TAG
    exec /usr/libexec/mu-verify/mu-verify.sh "$MANIFEST_FILE"
else
    echo "mu-init: No manifest found, exiting." | systemd-cat -t $TAG
fi