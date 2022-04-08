# Waggle Upload Sync

`systmed` timer service to `rsync` the contents of the node's upload data upload folder (i.e. `/media/plugin-data/uploads`) to an external drive.

## Customize Execution

To customize some parameters of the execution (such as the source directory) modify the `/etc/waggle/upload-sync.env`. The next execution of the service will pick up the `.env` file changes.
