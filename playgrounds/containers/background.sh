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

sudo apt-get install wget apt-transport-https gnupg
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update

# Trivy
snap install trivy

# Install Gvisor
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    mysql-client
curl -fsSL https://gvisor.dev/archive.key | sudo gpg --dearmor -o /usr/share/keyrings/gvisor-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/gvisor-archive-keyring.gpg] https://storage.googleapis.com/gvisor/releases release main" | sudo tee /etc/apt/sources.list.d/gvisor.list > /dev/null
sudo apt-get update && sudo apt-get install -y runsc

# Install Dive
DIVE_VERSION="0.12.0"
curl -LO "https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_amd64.tar.gz"
tar xzvf "dive_${DIVE_VERSION}_linux_amd64.tar.gz"
sudo mv dive /usr/local/bin/dive && rm "dive_${DIVE_VERSION}_linux_amd64.tar.gz"

# Skopeo
docker pull quay.io/skopeo/stable

# Step 2: Run the container and get its ID
container_id=$(docker run -d --entrypoint /bin/sh quay.io/skopeo/stable -c "sleep 300")

# Step 3: Copy the skopeo binary from the container to the host
docker cp "$container_id":/usr/bin/skopeo /usr/local/bin/skopeo

# Step 4: Make the binary executable
chmod +x /usr/local/bin/skopeo

# Step 5: Stop and remove the container
docker stop "$container_id"
docker rm "$container_id"

touch /tmp/finished