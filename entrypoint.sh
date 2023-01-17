#!/bin/bash

cd /opt/cert
sh ca.sh

if [ $DAEMON ]; then
  while [ 1=1 ]; do
    echo "==sleep=="
    sleep 1m
  done
fi
