#!/bin/bash
cd /root/tofu-example

if [ -f "hello.txt" ]; then
    echo "Failed file still exists hello.txt."
    exit 1
fi

if [ -f "morning.txt" ]; then
    echo "Failed file still exists morning.txt."
    exit 1
fi
