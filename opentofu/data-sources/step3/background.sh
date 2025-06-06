#!/bin/bash
# Create provider.tf file

cat <<EOF > ~/scenario/provider.tf
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

provider "kubernetes" { 
  config_path = "~/.kube/config"
  alias = "k8s"
}
EOF
