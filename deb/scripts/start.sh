#!/bin/bash
/scripts/sync_content.sh NOW_ONCE
exec supervisord -n
