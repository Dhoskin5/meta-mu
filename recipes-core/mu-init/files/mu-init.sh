#!/bin/sh

TAG="mu-init"

log() {
    echo "$TAG: $*" | systemd-cat -t "$TAG"
}

if [ -z "$UPDATE_INBOX_DIR" ]; then
    log "ERROR - UPDATE_INBOX_DIR is not set!"
    exit 1
fi

MANIFEST_FILE="$UPDATE_INBOX_DIR/manifest.json"

log "Checking for manifest in $UPDATE_INBOX_DIR"

if [ -f "$MANIFEST_FILE" ]; then
    log "Found manifest, triggering mu-verify"
    exec /usr/libexec/mu-verify/mu-verify.sh "$MANIFEST_FILE"
else
    log "No manifest found, exiting."
    exit 0
fi
