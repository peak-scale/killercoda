#!/bin/bash
cd /root/tofu-example

if [ -f "hello.txt" ]; then
    echo "hello.txt successfully created."
else
    echo "Failed to create hello.txt."
    exit 1
fi

tofu state ls | grep -q "hello.txt"
if [ $? -eq 0 ]; then
    echo "hello.txt is part of the state."
else
    echo "hello.txt is not part of the state."
    exit 1
fi