#!/bin/bash
echo "Setup Task..."
while [ ! -f /tmp/setup-step1 ]; do sleep 2; done
cd ~/dry
