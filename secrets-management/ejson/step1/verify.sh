#/bin/bash

# File exists
if [ ! -f /root/secrets.ejson ]; then
  exit 1
fi

if [ ! -f /root/ejson_privatekey ]; then
  exit 1
fi

# Decrypt the file
cat /root/ejson_privatekey | ejson decrypt /root/secrets.ejson --key-from-stdin

