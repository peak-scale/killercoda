#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step2"
mkdir -p "${SOLUTION_DIR}" || true

# Add Solution for review
cat << EOF > "${SOLUTION_DIR}/kubernetes.tf"
resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = "prod-environment"
  }
}

resource "kubernetes_service_account_v1" "serviceaccount" {
  metadata {
    name = "prod-sa"
    namespace = kubernetes_namespace_v1.namespace.metadata.0.name
    annotations = {
        "namespace-uid" = data.kubernetes_namespace_v1.namespace.metadata.0.uid
    }
  }
}

resource "kubernetes_secret_v1" "serviceaccount_token" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.serviceaccount.metadata.0.name,
      "namespace-uid" = data.kubernetes_namespace_v1.namespace.metadata.0.uid


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
    annotations = {
        "namespace-uid" = data.kubernetes_namespace_v1.namespace.metadata.0.uid
    }
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
diff <(hcl2json ~/scenario/kubernetes.tf) <(hcl2json "${SOLUTION_DIR}/kubernetes.tf")
if [ $? -ne 0 ]; then
  exit 1
fi