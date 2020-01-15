#!/bin/bash

set -o errexit

# set -x

DIRNAME=$(dirname $(readlink -f $0))

ps -Af | grep mosquitto | grep "sim$1" | awk '{ print $2 }' | sudo xargs kill -9 &> /dev/null || true
IP=$(sudo $DIRNAME/create-net-ns.sh $1)
MOSQUITTO_CONF="/tmp/mosquitto.sim$1.conf"
sudo bash -c "echo 'bind_address $IP' > $MOSQUITTO_CONF"
sudo ip netns exec "sim$1" mosquitto -c $MOSQUITTO_CONF -d
