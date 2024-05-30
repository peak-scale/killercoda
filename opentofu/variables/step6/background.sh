#!/bin/bash

mkdir ~/scenario/modules/service

# Create kubernetes.tf file
cat <<EOF > ~/scenario/modules/service/provider.tf
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

cat <<EOF > ~/scenario/modules/ingress/outputs.tf
output "ingress_name" {
  description = "The name of the ingress"
  value       = kubernetes_ingress_v1.ingress.metadata[0].name
}

output "service_cluster_ip" {
  description = "The cluster IP of the service"
}

output "service_target_port" {
  description = "The cluster IP of the service"
  value = local.target_port
}
EOF

cat <<EOF > ~/scenario/modules/ingress/variables.tf
variable "namespace" {
  description = "The namespace for the ingress resource"
  type        = string
}

variable "name" {
  description = "The name of the ingress resource"
  type        = string
}

variable "service_name" {
  description = "The name of the service to route traffic to"
  type        = string
}

variable "service_port" {
  description = "The port of the service to route traffic to"
  type        = number
}

variable "host" {
  description = "The host for the ingress rule"
  type        = string
}
EOF

cat <<EOF > ~/scenario/modules/ingress/main.tf
locals {
  service_port = 8080
  target_port  = 80
}

resource "kubernetes_service_v1" "service" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }

  spec {
    selector = {
      app = var.name
    }

    port {
      port        = local.service_port
      target_port = var.target_port
    }
    type = "ClusterIP"
  }
}



resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    rule {
      host = var.host

      http {
        path {
          path = "/"
          backend {
            service {
              name = var.name
              port {
                number = local.service_port
              }
            }
          }
        }
      }
    }
  }
}
EOF

cat <<EOF > ~/scenario/ingress.tf
module "k8s_ingress" {
  source         = "./modules/ingress"

  namespace      = local.namespace
  environment    = local.namespace
  ingress_name   = kubernetes_service_v1.service.metadata.0.name
  service_name   = "example-service"
  service_port   = 80
  host           = local.ingress
}
EOF



