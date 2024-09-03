#!/bin/bash
rm -f ~/scenario/local_file.tf

cat <<EOF > ~/scenario/main.tf
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
EOF

cat <<EOF > ~/scenario/kubernetes.tf
resource "kubernetes_pod_v1" "workload" {
  metadata {
    name = "nginx"
    namespace = "default"
  }
  
  spec {
    container {
      image = "nginx:latest"
      name  = "nginx"
      port {
        container_port = 8080
      }
    }
  }
}
EOF

kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: "nginx"
  namespace: "default"
spec:
  containers:
    - name: "busybox"
      image: "busybox:latest"
      ports:
        - containerPort: 80
      command: ["sleep", "infinity"]
EOF

cd ~/scenario && tofu init
