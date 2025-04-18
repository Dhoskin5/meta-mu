#!/bin/sh
echo "mu-init: Check for Updates Started" | systemd-cat -t mu-init

if ls /data/image/image-* 1>/dev/null 2>&1; then
    echo "mu-init: Local Update File Found" | systemd-cat -t mu-init
    systemctl start mu-update.service
else
    echo "mu-init: No Local Update File Found" | systemd-cat -t mu-init
    echo "mu-init: TESTING- STARTING mu-update.service" | systemd-cat -t mu-init
    systemctl start mu-update.service
    echo "mu-init: TESTING- STARTED mu-update.service" | systemd-cat -t mu-init
fi