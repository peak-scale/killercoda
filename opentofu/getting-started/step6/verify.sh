#!/bin/bash
cd ~/scenario

if [ -f "hello.txt" ]; then
    exit 1
fi

if [ -f "morning.txt" ]; then
    exit 1
fi
