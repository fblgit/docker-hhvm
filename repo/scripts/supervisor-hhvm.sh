#!/bin/bash
HHVM_CFG=${HHVM_CFG:-/etc/hhvm/server.ini}
if [ -e $HHVM_CFG ]; then
  exec hhvm --mode server -c $HHVM_CFG
else
  exec hhvm --mode server -vServer.Type=fastcgi -vServer.Port=9000
fi
