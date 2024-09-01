#!/bin/bash
set -x 
echo starting...
mkdir ~/scenario
cd ~/scenario

# Install OpenTofu
snap install opentofu --classic

# Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm -f get_helm.sh

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install minio bitnami/minio --version 14.6.2 -n minio-test --create-namespace
helm install minio bitnami/minio --version 14.6.2 -n minio-prod --create-namespace

curl https://dl.min.io/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o /usr/local/bin/mc
chmod +x /usr/local/bin/mc

MINIO_TEST_USER=$(kubectl get secret -n minio-test minio -o jsonpath='{.data.root-user}' | base64 -d)
MINIO_TEST_PASSWORD=$(kubectl get secret -n minio-test minio -o jsonpath='{.data.root-password}' | base64 -d)
MINIO_TEST_URL=""

cat <<EOF > /etc/systemd/system/minio-test-port-forward.service
[Unit]
Description=MinIO Test Port-Forward
After=network.target

[Service]
ExecStart=/usr/bin/kubectl port-forward -n minio-test svc/minio 9000:9000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
systemctl enable minio-test-port-forward.service
systemctl start minio-test-port-forward.service




touch /tmp/finished
