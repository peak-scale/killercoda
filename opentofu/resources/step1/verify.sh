#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step1"
mkdir -p "${SOLUTION_DIR}" || true

# Add Solution for review
cat << 'EOF' > "${SOLUTION_DIR}/kubernetes.tf"
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

  lifecycle {
    ignore_changes = [
        metadata[0].annotations["cni.projectcalico.org/containerID"],
        metadata[0].annotations["cni.projectcalico.org/podIP"],
        metadata[0].annotations["cni.projectcalico.org/podIPs"]
    ]
  }  
}
EOF

# Verify the solution
result=$(hcl2json ~/scenario/kubernetes.tf | jq '(
  .resource.kubernetes_pod_v1.workload[0].metadata[0].namespace == "${kubernetes_namespace_v1.namespace.metadata.0.name}"
) and (
  .resource.kubernetes_pod_v1.workload[0].spec[0].service_account_name == "${kubernetes_service_account_v1.serviceaccount.metadata.0.name}"
) and (
  .resource.kubernetes_secret_v1.serviceaccount_token[0].metadata[0].annotations."kubernetes.io/service-account.name" == "${kubernetes_service_account_v1.serviceaccount.metadata.0.name}"
) and (
  .resource.kubernetes_secret_v1.serviceaccount_token[0].metadata[0].namespace == "${kubernetes_namespace_v1.namespace.metadata.0.name}"
) and (
  .resource.kubernetes_service_account_v1.serviceaccount[0].metadata[0].namespace == "${kubernetes_namespace_v1.namespace.metadata.0.name}"
)')
if [ "$result" = "false" ]; then
  exit 1
fi