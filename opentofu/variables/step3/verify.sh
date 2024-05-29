#!/bin/bash

# Add Solution for review
mkdir -p ~/.solutions/step2 || true
cat << 'EOF' > ~/.solutions/step2/kubernetes.tf
resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = "${var.environment}-environment"
  }
}

resource "kubernetes_service_account_v1" "serviceaccount" {
  metadata {
    name = "${var.environment}-sa"
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

cat << 'EOF' > ~/.solutions/step2/variables.tf
variable "environment" {
  type = string
  description = "The environment name"
  default = "prod"
}
EOF

cat << 'EOF' > ~/.solutions/step2/terraform.tfvars
environment = "test"
EOF


diff -w  -sB ~/.solutions/step1/kubernetes.tf ~/scenario/kubernetes.tf
if [ $? -ne 0 ]; then
  exit 1
fi