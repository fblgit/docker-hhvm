#!/bin/bash
/scripts/mount_ram.sh
exec supervisord -n
