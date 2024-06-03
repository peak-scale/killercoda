#!/bin/bash
set -x 
echo starting...

# Install Opentofu
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method deb
rm install-opentofu.sh

# Install HCL2JSON
HCL2JSON_VERSION="0.6.3"
wget "https://github.com/tmccombs/hcl2json/releases/download/v${HCL2JSON_VERSION}/hcl2json_linux_amd64" -O /tmp/hcl2json
mv /tmp/hcl2json /usr/local/bin/hcl2json
chmod +x /usr/local/bin/hcl2json

mkdir ~/scenario
cd ~/scenario

cat << 'EOF' > "${HOME}/scenario/kubernetes.tf"
locals {
  replicas = 3
}

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
  for_each = local.replicas

  metadata {
    name      = "nginx-${each.key}"
    namespace = kubernetes_namespace_v1.namespace.metadata[0].name
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

kubectl create ns prod-environment

kubectl apply -f - <<EOF
---
apiVersion: v1
kind: Pod
metadata:
  name: "nginx-1"
  namespace: "prod-environment"
spec:
  serviceAccountName: "prod-sa"
  containers:
    - name: "nginx"
      image: "nginx:latest"
      ports:
        - containerPort: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: "nginx-2"
  namespace: "prod-environment"
spec:
  serviceAccountName: "prod-sa"
  containers:
    - name: "nginx"
      image: "nginx:latest"
      ports:
        - containerPort: 80
EOF

touch /tmp/finished