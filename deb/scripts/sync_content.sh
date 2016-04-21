#!/bin/bash
## The Purpose is Execute a few Syncs, fully randomly in time.
## Creates a non concurrent large scale event model
## I suppose you dont want to run this at the same time in 500 containers.
SYNC_ENABLED=${SYNC_ENABLED:-1}
## If Sync is Disabled then it will only sleep
# Major Sync Invoke every...
REPEAT_CYCLE=18
# Wait per each Cycle
WAIT_CYCLE=1800
# LOG
LOG_FILE=/mnt/logs/content_sync.log

# Define Major Sync Actions (heavy)
function major_sync {
  rsync -avz --delete -q /mnt/cache/ /var/www/
  echo "`date` $HOSTNAME >> HEAVY SYNC [OK]">>$LOG_FILE
}
# Define Minor Sync Actions (light)
function minor_sync {
  rsync -avz -q /mnt/fpc/ /mnt/fpc_cluster/
  rsync -avz -q --delete /mnt/fpc_cluster/ /mnt/fpc/
  echo "`date` $HOSTNAME >> LIGHT SYNC [OK]">>$LOG_FILE
}
# Initial Sync Purge
function purge_sync {
  rsync -avz -q --delete /mnt/fpc_cluster/ /mnt/fpc/
  echo "`date` $HOSTNAME >> PURGE SYNC [OK]">>$LOG_FILE
}
# On All Sync
function all_sync {
  major_sync
  minor_sync
}
############
if [[ "$1" == "NOW_ONCE" ]]; then
  purge_sync
  all_sync
fi
if [[ "$1" == "NOW_DAEMON" ]]; then
  all_sync
fi
CYCLE=0

while sleep 0; do
  RN=$((( RANDOM % 180 )))
  # Ensure in large scale its not concurrent...
  sleep $RN
  if [[ "$SYNC_ENABLED" == "1" ]]; then
    if [[ "$CYCLE" == "$REPEAT_CYCLE" ]]; then
      # Major Sync
      major_sync
      CYCLE=0
    fi
    sleep $RN
    minor_sync
  fi
  CYCLE=$(($CYCLE+1))
  sleep $WAIT_CYCLE
done
