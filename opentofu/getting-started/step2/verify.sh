#!/bin/bash
cd ~/scenario

DIRECTORY=".terraform"
if [ ! -d "$DIRECTORY" ]; then
  echo "$DIRECTORY not does exist." && exit 1
fi

FILE=".terraform.lock.hcl"
if [ ! -f "$FILE" ]; then
  echo "$FILE not does exist." && exit 1
fi
