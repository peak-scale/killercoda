provider "harbor" {
  url      = var.harbor_url
  username = var.harbor_username
  password = var.harbor_password
  insecure = var.harbor_insecure
}
