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

if [ ! -f "$MANIFEST_FILE" ]; then
    log "No manifest found, exiting."
    exit 0
fi

log "Found manifest — triggering mu-update-daemon via D-Bus"

# call update daemon via D-Bus
RESULT=$(gdbus call \
    --system \
    --dest org.mu.Update \
    --object-path /org/mu/Update \
    --method org.mu.Update.TriggerUpdate \
    2>&1)

if echo "$RESULT" | grep -q '(true,'; then
    log "mu-update-daemon accepted the update request"
    exit 0
else
    log "mu-update-daemon rejected the update: $RESULT"
    exit 1
fi
