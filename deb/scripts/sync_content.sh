#!/bin/bash
SYNC_ENABLED=${SYNC_ENABLED:-1}
# Major Sync Invoke every...
REPEAT_CYCLE=18
# Wait per each Cycle
WAIT_CYCLE=1800

# Define Major Sync Actions (heavy)
function major_sync {
  rsync -avz --delete -q /mnt/cache/ /var/www/
  # logger
}
# Define Minor Sync Actions (light)
function minor_sync {
  rsync -avz -q /mnt/fpc/ /mnt/fpc_cluster/
  rsync -avz -q --delete /mnt/fpc_cluster/ /mnt/fpc/
}
# On All Sync
function all_sync {
  major_sync
  minor_sync
}
############
if [[ "$1" == "NOW_ONCE" ]]; then
  all_sync && exit 0
fi
if [[ "$1" == "NOW_DAEMON" ]]; then
  all_sync
fi
CYCLE=0
RANDOM=$(((RANDOM%120)))
if [[ "$SYNC_ENABLED" == "1" ]]; then
  while sleep 0; do
  RANDOM=$(((RANDOM%180)))
  # Ensure in large scale its not concurrent... 
  sleep $RANDOM
  if [[ "$CYCLE" == "$REPEAT_CYCLE" ]]; then
    # Major Sync
    major_sync
    CYCLE=0
  fi
  minor_sync
  CYCLE=$(($CYCLE+1))
  sleep $WAIT_CYCLE
fi
