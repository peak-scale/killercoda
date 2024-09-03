#!/bin/bash
cd ~/scenario

FILE="/root/hello-example.plan"
if [ ! -f "$FILE" ]; then
  echo "$FILE not does exist." && exit 1
fi


FILE2="/root/hello-example.plan.txt"
if [ ! -f "$FILE2" ]; then
  echo "$FILE2 not does exist." && exit 1
fi

actual_output=$(tofu show "/root/hello-example.plan")
stored_output=$(cat /root/hello-example.plan.txt)

diff -w -B <(echo "$actual_output") <(echo "$stored_output")
if [ $? -ne 0 ]; then
  exit 1
fi