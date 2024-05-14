#!/bin/bash
cd /root/tofu-example

DIRECTORY="/root/tofu-example/.terraform"
if [ ! -d "$DIRECTORY" ]; then
  echo "$DIRECTORY not does exist." && exit 1
fi

FILE="/root/tofu-example/.terraform.lock.hcl"
if [ ! -f "$FILE" ]; then
  echo "$FILE not does exist." && exit 1
fi