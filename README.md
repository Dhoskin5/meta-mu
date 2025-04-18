# meta-mu

> A secure and modular update framework for Yocto-based embedded Linux systems.

## Overview

`meta-mu` is a portable Yocto/OpenEmbedded layer that enables:

- Manifest-driven update detection
- Secure signature verification with Minisign
- Integration with systemd-based boot workflows
- OTA-ready architecture with squashfs + overlayfs in mind

## Layer Structure

- `mu-init`: Detects updates and triggers execution
- `mu-update`: Verifies manifests and applies updates
- `manifest.json`: Defines update version, payloads, and SHA256 hashes
- `systemd services`: Ensure proper sequencing (e.g. after `network-online.target`, `time-sync.target`)
