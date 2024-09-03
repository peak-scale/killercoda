#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step2"
mkdir -p "${SOLUTION_DIR}" || true

# Add Solution for review
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

cat << 'EOF' > "${SOLUTION_DIR}/variables.tf"
variable "environment" {
  type = string
  description = "The environment name"
  default = "prod"
  validation {
    condition = var.environment == "prod" || var.environment == "test" || var.environment == "dev"
    error_message = "The environment must be either prod, test or dev"
  }
}
EOF

cat << 'EOF' > "${SOLUTION_DIR}/terraform.tfvars"
environment = "test"
EOF

# Verify the solution
if ! [ -f ~/scenario/terraform.tfvars ]; then
  exit 1
fi

diff <(hcl2json ~/scenario/variables.tf) <(hcl2json ${SOLUTION_DIR}/variables.tf)
if [ $? -ne 0 ]; then
  exit 1
fi

result=$(hcl2json kubernetes.tf | jq '(
  .resource.kubernetes_namespace_v1.namespace[0].metadata[0].name == "${var.environment}-environment"
) and (
  .resource.kubernetes_service_account_v1.serviceaccount[0].metadata[0].name == "${var.environment}-sa"
)')
if [ "$result" = "false" ]; then
  exit 1
fi