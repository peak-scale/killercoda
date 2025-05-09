#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step3"
mkdir -p "${SOLUTION_DIR}" || true

# Add Solution for review
cat << 'EOF' > "${SOLUTION_DIR}/kubernetes.tf"
resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = "dev-environment"
  }
}

resource "kubernetes_service_account_v1" "serviceaccount" {
  metadata {
    name = "dev-sa"
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

  depends_on = [
    kubernetes_namespace_v1.namespace
  ]

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}


resource "kubernetes_pod_v1" "workload" {
  metadata {
    name = "dev-pod"
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

  depends_on = [
    kubernetes_service_account_v1.serviceaccount
  ]

  lifecycle {
    ignore_changes = [
        metadata[0].annotations["cni.projectcalico.org/containerID"],
        metadata[0].annotations["cni.projectcalico.org/podIP"],
        metadata[0].annotations["cni.projectcalico.org/podIPs"]
    ]
    precondition {
      condition     = kubernetes_namespace_v1.namespace.metadata[0].name != "prod-environment"
      error_message = "The namespace must not be prod-environment"
    }
  }
}
EOF

# Verify the Solution
result=$(hcl2json ~/scenario/kubernetes.tf | jq '(
  any(.resource.kubernetes_pod_v1.workload[0].depends_on[]; . == "${kubernetes_service_account_v1.serviceaccount}")
)')
if [[ -z "$result" || "$result" = "false" ]]; then
  exit 1
fi

diff -w -B <(hcl2json ~/scenario/kubernetes.tf | jq '.resource.kubernetes_pod_v1.workload[0].lifecycle[0].precondition[0]') <(hcl2json "${SOLUTION_DIR}/kubernetes.tf" | jq '.resource.kubernetes_pod_v1.workload[0].lifecycle[0].precondition[0]')
if [ $? -ne 0 ]; then
  exit 1
fi

unset result
result=$(hcl2json ~/scenario/kubernetes.tf | jq '(
  any(.resource.kubernetes_pod_v1.workload[0].lifecycle[0].ignore_changes[]; . == "${metadata[0].annotations[\"cni.projectcalico.org/podIPs\"]}")
) and (
  any(.resource.kubernetes_pod_v1.workload[0].lifecycle[0].ignore_changes[]; . == "${metadata[0].annotations[\"cni.projectcalico.org/containerID\"]}")
) and (
  any(.resource.kubernetes_pod_v1.workload[0].lifecycle[0].ignore_changes[]; . == "${metadata[0].annotations[\"cni.projectcalico.org/podIP\"]}")
)')
if [[ -z "$result" || "$result" = "false" ]]; then
  exit 1
fi
