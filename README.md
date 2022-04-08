# Waggle Upload Sync

`systmed` timer service to `rsync` the contents of the node's upload data upload folder (i.e. `/media/plugin-data/uploads`) to an external drive.

>*Note*: the external drive partition should be formatted as `ext4` to ensure compatibility and allow large (ex. 10GB) files sizes.

## Installation and Post-Install Configuration

After installing the ∫Debian package the service will automatically run and fail as the default sync device is `/dev/dummy`. To enable the service to sync to the desired external media the **following** steps need to be taken:

1. edit the `SYNC_DRIVE` variable in the `/etc/waggle/upload-sync.env` file to the external media (ex. `/dev/sdb2`) path
2. wait for the service to auto-run or force the service to start via `systemctl start waggle-upload-sync.service`

>*Note*: you can see the logs for the service via `journalctl -fu waggle-upload-sync`

## Customize Execution

To customize some parameters of the execution (such as the source directory) modify the `/etc/waggle/upload-sync.env`. The next execution of the service will pick up the `.env` file changes.
