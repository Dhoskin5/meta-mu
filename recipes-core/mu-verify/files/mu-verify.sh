#!/bin/sh

TAG="mu-verify"
MANIFEST="$1"
SIGNATURE="${MANIFEST}.sig"
PUBLIC_KEY_DIR="/etc/mu-verify/trusted.d"
UPDATE_DIR="$(dirname "$MANIFEST")"

log() {
    echo "$TAG: $*" | systemd-cat -t "$TAG"
}

if [ ! -f "$MANIFEST" ] || [ ! -f "$SIGNATURE" ]; then
    log "Missing manifest or signature"
    exit 1
fi

# Step 1: Signature Verification
log "Verifying manifest signature..."

verified=false
for PUBKEY in "$PUBLIC_KEY_DIR"/*.pub; do
    if minisign -V -p "$PUBKEY" -m "$MANIFEST" -x "$SIGNATURE" 2>/dev/null; then
        log "Signature verified with $PUBKEY"
        verified=true
        break
    fi
done

if [ "$verified" != true ]; then
    log "Signature verification failed"
    exit 2
fi

# Step 2: Payload Validation
log "Parsing manifest and validating payloads..."

jq -r '.files[] | "\(.name) \(.sha256)"' "$MANIFEST" | while read -r FILE EXPECTED_HASH; do
    FILE_PATH="$UPDATE_DIR/$FILE"

    if [ ! -f "$FILE_PATH" ]; then
        log "Missing payload $FILE_PATH"
        exit 3
    fi

    ACTUAL_HASH=$(sha256sum "$FILE_PATH" | awk '{print $1}')

    if [ "$ACTUAL_HASH" != "$EXPECTED_HASH" ]; then
        log "SHA256 mismatch for $FILE"
        log "Expected: $EXPECTED_HASH"
        log "Actual:   $ACTUAL_HASH"
        exit 4
    else
        log "Verified $FILE"
    fi
done

log "All payloads verified successfully"
exit 0
