#!/bin/bash
/data/mount_ram.sh
exec supervisord -n
