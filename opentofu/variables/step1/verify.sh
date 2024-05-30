#!/bin/bash

# Add Solution for review
mkdir -p ~/.solutions/step1 || true
cat << 'EOF' > ~/.solutions/step1/kubernetes.tf
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

# Verify the solution
hcl2json kubernetes.tf | jq '(
  .resource.kubernetes_pod_v1.workload[0].metadata[0].namespace == "kubernetes_namespace_v1.namespace.metadata.0.name"
) and (
  .resource.kubernetes_pod_v1.workload[0].spec[0].service_account_name == "kubernetes_service_account_v1.serviceaccount.metadata.0.name"
) and (
  .resource.kubernetes_secret_v1.serviceaccount_token[0].metadata[0].annotations."kubernetes.io/service-account.name" == "kubernetes_service_account_v1.serviceaccount.metadata.0.name"
) and (
  .resource.kubernetes_secret_v1.serviceaccount_token[0].metadata[0].namespace == "kubernetes_namespace_v1.namespace.metadata.0.name"
) and (
  .resource.kubernetes_service_account_v1.serviceaccount[0].metadata[0].namespace == "kubernetes_namespace_v1.namespace.metadata.0.name"
)'