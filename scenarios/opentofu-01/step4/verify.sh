#!/bin/bash
cd /root/tofu-example

if [ ! -f "hello.txt" ]; then
    echo "Failed to create hello.txt."
    exit 1
fi

tofu state ls | grep -q "local_file.example"
if [ $? -ne 0 ]; then
    echo "hello.txt is not part of the state."
    exit 1
fi