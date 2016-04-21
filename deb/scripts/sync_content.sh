#!/bin/bash
SYNC_ENABLED=${SYNC_ENABLED:-1}
if [[ "$SYNC_ENABLED" == "1" ]]; then
  rsync -avz --delete -q /mnt/cache/ /var/www/
  rsync -avz -q /mnt/fpc/ /mnt/fpc_cluster/
  rsync -avz -q --delete /mnt/fpc_cluster/ /mnt/fpc/
fi
