#!/bin/bash

cd /root/gpg

echo "Import GPG Private-Key 1 (${PWD}keys/keys-1/private.key) 🦄"
gpg --import keys/keys-1/private.key


echo "Import GPG Private-Key 2 (${PWD}keys/keys-2/private.key) 🦄"
gpg --import keys/keys-1/private.key