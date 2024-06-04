#!/bin/bash
SOLUTION_DIR="${HOME}/.solutions/step4"
mkdir -p "${SOLUTION_DIR}" || true

# Create provider.tf file
cat <<EOF > provider.tf
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
}

provider "kubernetes" {
  alias = "k8s"
  config_path = "~/.kube/config"
  ignore_annotations = [
    "cni\.projectcalico\.org\/*"
  ]
}
EOF


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
  provider = kubernetes.k8s
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
      condition     = kubernetes_namespace_v1.namespace.metadata[0].name == "prod-environment"
      error_message = "The namespace must be prod-environment"
    }
  }
}
EOF

# Verify the Solution
result=$(hcl2json ~/scenario/kubernetes.tf | jq '(
  .resource.kubernetes_pod_v1.workload[0].provider == "${kubernetes.k8s}"
)')
if [ "$result" = "false" ]; then
  exit 1
fi


result=$(hcl2json ~/scenario/provider.tf | jq '
  any(.provider.kubernetes[]; .alias == "${k8s}")
')
if [ "$result" = "false" ]; then
  exit 1
fi

