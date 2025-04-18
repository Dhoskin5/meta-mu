#!/bin/sh
set -e

TAG="mu-update"
UPDATE_DIR="/data/image"
UPDATE_PATTERN="update-*.tar.gz"
WORK_DIR="/tmp/mu-update"
DEFAULT_TARGET_DIR="/"

log() {
    echo "$1" | systemd-cat -t $TAG
}

log "mu-update: Starting..."

# Locate update file
UPDATE_FILE=$(find "$UPDATE_DIR" -maxdepth 1 -type f -name "$UPDATE_PATTERN" 2>/dev/null | head -n 1)
if [ -z "$UPDATE_FILE" ]; then
    log "mu-update: No update file found in $UPDATE_DIR"
    exit 0
fi

log "mu-update: Found update file: $UPDATE_FILE"

# Extract update
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
tar -xzf "$UPDATE_FILE" -C "$WORK_DIR"

MANIFEST="$WORK_DIR/manifest.json"
if [ ! -f "$MANIFEST" ]; then
    log "mu-update: ERROR: manifest.json missing. Aborting."
    exit 1
fi

# Parse manifest
VERSION=$(grep '"version"' "$MANIFEST" | cut -d '"' -f 4)
PRE_SCRIPT=$(grep '"pre_script"' "$MANIFEST" | cut -d '"' -f 4)
POST_SCRIPT=$(grep '"post_script"' "$MANIFEST" | cut -d '"' -f 4)
TARGET_DIR=$(grep '"target_dir"' "$MANIFEST" | cut -d '"' -f 4)

[ -z "$TARGET_DIR" ] && TARGET_DIR="$DEFAULT_TARGET_DIR"

log "mu-update: Version: $VERSION"
log "mu-update: Target dir: $TARGET_DIR"

# Run pre-update script if defined
if [ -n "$PRE_SCRIPT" ] && [ -x "$WORK_DIR/$PRE_SCRIPT" ]; then
    log "mu-update: Running pre-update script: $PRE_SCRIPT"
    sh "$WORK_DIR/$PRE_SCRIPT"
fi

# Apply payload
PAYLOAD_DIR="$WORK_DIR/payload"
if [ -d "$PAYLOAD_DIR" ]; then
    log "mu-update: Applying payload to $TARGET_DIR"
    tar -cf - -C "$PAYLOAD_DIR" . | tar -xf - -C "$TARGET_DIR"
else
    log "mu-update: ERROR: No payload/ directory found."
    exit 1
fi

# Run post-update script if defined
if [ -n "$POST_SCRIPT" ] && [ -x "$WORK_DIR/$POST_SCRIPT" ]; then
    log "mu-update: Running post-update script: $POST_SCRIPT"
    sh "$WORK_DIR/$POST_SCRIPT"
fi

# Write version file for tracking
echo "$VERSION" > /etc/mu-version
log "mu-update: Update $VERSION applied successfully."

# Rename to mark as applied
mv "$UPDATE_FILE" "$UPDATE_FILE.applied"

# Clean up
rm -rf "$WORK_DIR"
log "mu-update: Cleanup complete."

exit 0
