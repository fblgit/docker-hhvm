#!/bin/bash
ENABLED_RAMDISK=${ENABLED_RAMDISK:-1}

if [[ "$ENABLED_RAMDISK" == "1" ]]; then
  apt-get install rsync -qy
  rsync -avz -q /mnt/cache/ /var/www/
  echo " Ramdisk Sync"
  if [[ -d "/mnt/fpc_cluster" ]]; then
    if [[ -d "/mnt/fpc" ]]; then
      rsync -avz -q --delete /mnt/fpc_cluster/ /mnt/fpc/
      echo "FPC Sync"
    fi
  fi
fi
