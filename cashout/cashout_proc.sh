#!/bin/bash

cat '/root/deploy/debug_port.log' | while read line
do
  echo "当前端口port $line "
  sh /root/swarm/cashout/cashout_api.sh cashout-all 5  $line
  echo "cash out done $line"
done