#!/bin/bash
echo "Setup Task..."
while [ ! -f /tmp/setup-step1 ]; do sleep 1; done

cd ~/dry
