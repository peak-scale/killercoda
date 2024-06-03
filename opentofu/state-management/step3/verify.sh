#!/bin/bash
cd /root/tofu-example

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

if [ "$actual_output" == "$stored_output" ]; then
    echo "The plan content matches the stored file."
else
    echo "The plan content does not match the stored file."
    exit 1
fi