#!/bin/bash

# Create kubernetes.tf file
cat <<EOF > kubernetes.tf
resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = "prod-environment"
  }
}

resource "kubernetes_service_account_v1" "serviceaccount" {
  metadata {
    name = "prod-sa"
    namespace = "prod-environment"
  }
}

resource "kubernetes_secret_v1" "serviceaccount_token" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = "prod-sa"
    }
    namespace = "prod-environment"
    generate_name = "terraform-example-"
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}


resource "kubernetes_pod_v1" "workload" {
  metadata {
    name = "nginx"
    namespace = "prod-environment"
    labels = local.common_labels
    annotations = local.deploy_annotations
  }

  spec {
    service_account_name = "prod-sa"
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

# Apply configuration
tofu init && tofu plan && tofu apply -auto-approve
touch /tmp/setup-step1
