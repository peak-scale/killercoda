#!/bin/bash
set -x 
echo starting...

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Install TalosCTL
curl -sL https://talos.dev/install | sh

# Install TALM
TALM_VERSION="0.8.2"
TALM_SOURCE="aenix-io/talm"
curl -LO "https://github.com/${TALM_SOURCE}/releases/download/v${TALM_VERSION}/talm-linux-arm64"
mv ./talm-linux-arm64 /usr/bin/talm

touch /tmp/finished