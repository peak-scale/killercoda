#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step4"
mkdir -p "${SOLUTION_DIR}" || true

# Add Solution for review
cat << 'EOF' > "${SOLUTION_DIR}/locals.tf"
locals {
  common_labels = {
    environment = var.environment
  }
  deploy_annotations = {
    created_at = timestamp()
  }
}
EOF

cat << 'EOF' > "${SOLUTION_DIR}/kubernetes.tf"
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

  depends_on = [kubernetes_namespace_v1.namespace]
}

resource "kubernetes_secret_v1" "serviceaccount_token" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.serviceaccount.metadata.0.name
    }
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
    generate_name = "terraform-example-"    
  }

  depends_on = [kubernetes_service_account_v1.serviceaccount]

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}


resource "kubernetes_pod_v1" "workload" {
  metadata {
    name = "nginx"
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
    labels = local.common_labels
    annotations = local.deploy_annotations
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

  depends_on = [kubernetes_secret_v1.serviceaccount_token]
}
EOF

# Verify
diff <(hcl2json ~/scenario/locals.tf) <(hcl2json ${SOLUTION_DIR}/locals.tf)
diff <(hcl2json ~/scenario/kubernetes.tf | jq '.resource.kubernetes_pod_v1.workload[0].metadata') <(hcl2json ${SOLUTION_DIR}/kubernetes.tf | jq '.resource.kubernetes_pod_v1.workload[0].metadata')

