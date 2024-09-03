#!/bin/bash
kubectl create namespace prod-environment
kubectl create serviceaccount prod-sa -n prod-environment
kubectl run nginx --image=nginx:latest -n prod-environment

cat <<EOF > production.tf
resource "kubernetes_namespace_v1" "production" {
  metadata {
    name = "prod-environment"
  }
}

resource "kubernetes_service_account_v1" "production" {
  metadata {
    name = "prod-sa"
    namespace = kubernetes_namespace_v1.production.metadata.0.name
  }
}

resource "kubernetes_pod_v1" "production" {
  metadata {
    name = "nginx"
    namespace = kubernetes_namespace_v1.production.metadata.0.name
  }

  spec {
    service_account_name = kubernetes_service_account_v1.production.metadata.0.name
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