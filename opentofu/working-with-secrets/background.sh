#!/bin/bash
set -x 
echo starting...
mkdir ~/solutions

snap install opentofu --classic

# Install EJSON
EJSON_VERSION="1.5.1"
wget "https://github.com/Shopify/ejson/releases/download/v${EJSON_VERSION}/ejson_${EJSON_VERSION}_linux_amd64.tar.gz
" -O /tmp/ejson.deb
sudo dpkg -i /tmp/ejson.deb
sudo apt-get install -f

touch /tmp/finished
