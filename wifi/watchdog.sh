#!/bin/sh

# Use existing IP in your network that the camera will ping & use to verify its connection status (generally your AP IP)
HOST="192.168.1.1"

# How many pings in one batch (default=10)
COUNT=10

# What percentage of network availability you require (default=70 = 3 drops of 10 will cause network restart)
PERCENT=70

# How long to wait at most for each ping to arrive (default=3 seconds)
WAIT=3

# Action to take when the network is down
ACTION=/tmp/fuse_d/wifi/sta.sh

# COUNT * WAIT = time (in seconds) before camera inits a restart if there is a drop. Higher COUNT, better precision for percentage 

while [ 1 ]
  do
    count=$(ping -W $WAIT -c $COUNT $HOST | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
    if [ $count -lt $(( $COUNT * $PERCENT / 100 )) ]; then
      $ACTION
    fi
  done
