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

# create the temp mount point
if ! mkdir -p ${SYNC_MOUNT}; then
    echo "ERROR: failed to create mount point [${SYNC_MOUNT}]"
    exit 2
fi

# mount the drive
if ! mount ${SYNC_DRIVE} ${SYNC_MOUNT}; then
    echo "ERROR: failed to mount drive [${SYNC_DRIVE} ${SYNC_MOUNT}]"
    exit 3
fi
trap cleanup EXIT

# validate the mount
if ! mountpoint ${SYNC_MOUNT}; then
    echo "ERROR: failed to verify mountpoint [${SYNC_MOUNT}]"
    exit 4
fi

# create the mount uploads folder
if ! mkdir -p ${rsync_dest}; then
    echo "ERROR: unable to create mount uploads folder [${rsync_dest}]"
    exit 5
fi

# execute rsync
rsync -av --delete ${SYNC_SOURCE} ${rsync_dest}

echo "Sync complete [${SYNC_SOURCE} -> ${SYNC_DRIVE} (${rsync_dest})"