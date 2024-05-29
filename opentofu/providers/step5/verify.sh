#!/bin/bash
cd /root/tofu-example

tofu state ls | grep -q "local_file.example"
if [ $? -ne 0 ]; then
    echo "hello.txt is not part of the state."
    exit 1
fi

tofu state ls | grep -q "local_file.morning"
if [ $? -ne 0 ]; then
    echo "local_file.morning is not part of the state."
    exit 1
fi