locals {
  common_labels = {
    environment = var.environment
  }
  deploy_annotations = {
    created_at = timestamp()
  }
}