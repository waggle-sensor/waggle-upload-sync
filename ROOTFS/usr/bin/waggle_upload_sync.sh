#!/bin/bash

rsync_dest=${SYNC_MOUNT}/${SYNC_DST}

function cleanup()
{
    echo "Sync & cleanup mount [${SYNC_DRIVE} (${SYNC_MOUNT})]"
    sync
    umount ${SYNC_MOUNT} || true
    rm -rf ${SYNC_MOUNT}
}

echo "Starting rsync [${SYNC_SOURCE} -> ${SYNC_DRIVE} (${rsync_dest})]"

# check if the drive is present
if ! lsblk ${SYNC_DRIVE}; then
    echo "ERROR: unable to locate drive [${SYNC_DRIVE}]"
    exit 1
fi

# check if the drive matches the USB (by serial)
found=
for dev in /dev/disk/by-id/*; do
    if echo $dev | grep -q ${SYNC_USB_SERIAL}; then
        if [ "$(readlink -f $dev)" == "${SYNC_DRIVE}" ]; then
            echo "Device [$SYNC_DRIVE] enumerated from [${dev}]"
            found=1
        fi
    fi
done
if [ -z "${found}" ]; then
    echo "ERROR: Unable to match USB serial [${SYNC_USB_SERIAL}] to device [${SYNC_DRIVE}]"
    exit 2
fi

# create the temp mount point
if ! mkdir -p ${SYNC_MOUNT}; then
    echo "ERROR: failed to create mount point [${SYNC_MOUNT}]"
    exit 3
fi

# mount the drive
if ! mount ${SYNC_DRIVE} ${SYNC_MOUNT}; then
    echo "ERROR: failed to mount drive [${SYNC_DRIVE} ${SYNC_MOUNT}]"
    exit 4
fi
trap cleanup EXIT

# validate the mount
if ! mountpoint ${SYNC_MOUNT}; then
    echo "ERROR: failed to verify mountpoint [${SYNC_MOUNT}]"
    exit 5
fi

# create the mount uploads folder
if ! mkdir -p ${rsync_dest}; then
    echo "ERROR: unable to create mount uploads folder [${rsync_dest}]"
    exit 6
fi

# execute rsync
rsync -av \
    --delete \
    --progress \
    --itemize-changes \
    --partial-dir=.partial/ \
    ${SYNC_SOURCE} ${rsync_dest}

echo "Sync complete [${SYNC_SOURCE} -> ${SYNC_DRIVE} (${rsync_dest})"