#!/bin/bash

if [ "$(id -u)" -eq 0 ]; then
  echo 'This script can only run by user (non-root user)'
  exit 1
fi

export UID

docker-compose up
