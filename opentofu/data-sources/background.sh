#!/bin/bash
echo starting...

snap install opentofu --classic

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
  ignore_annotations = [
    "cni\\\\.projectcalico\\\\.org\\\\/*"
  ]
}
EOF


cat <<EOF > kubernetes.tf
resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = "prod-environment"
  }
}

resource "kubernetes_service_account_v1" "serviceaccount" {
  metadata {
    name = "prod-sa"
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
  }
}

resource "kubernetes_secret_v1" "serviceaccount_token" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.serviceaccount.metadata.0.name
    }
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
    generate_name = "terraform-example-"    
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}


resource "kubernetes_pod_v1" "workload" {
  metadata {
    name = "nginx"
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
  }

  spec {
    service_account_name = kubernetes_service_account_v1.serviceaccount.metadata.0.name
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

tofu init
touch /tmp/finished