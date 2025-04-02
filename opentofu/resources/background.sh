#!/bin/bash
echo starting...

curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method deb
rm -f install-opentofu.sh

# Install HCL2JSON
HCL2JSON_VERSION="0.6.3"
wget "https://github.com/tmccombs/hcl2json/releases/download/v${HCL2JSON_VERSION}/hcl2json_linux_amd64" -O /tmp/hcl2json
mv /tmp/hcl2json /usr/local/bin/hcl2json
chmod +x /usr/local/bin/hcl2json

mkdir ~/scenario
cd ~/scenario

# Create provider.tf file
cat <<EOF > provider.tf
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.30.0"
    }
  }
}

provider "kubernetes" { 
  config_path = "~/.kube/config"
}
EOF


# Add Solution for review
cat << 'EOF' > ~/scenario/kubernetes.tf
resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = "dev-environment"
  }
}

resource "kubernetes_service_account_v1" "serviceaccount" {
  metadata {
    name = "dev-sa"
    namespace = "dev-environment"
  }
}

resource "kubernetes_secret_v1" "serviceaccount_token" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = "dev-sa"
    }
    namespace = "dev-environment"
    generate_name = "terraform-example-"
  }

  depends_on = [
    kubernetes_namespace_v1.namespace
  ]

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}

resource "kubernetes_pod_v1" "workload" {
  metadata {
    name = "dev-pod"
    namespace = "dev-environment"
  }
  
  spec {
    service_account_name = "dev-sa"
    container {
      image = "nginx:latest"
      name  = "nginx"
      port {
        container_port = 80
      }
    }
  }
}
EOF

touch /tmp/finished