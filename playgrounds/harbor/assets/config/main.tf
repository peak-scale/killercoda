provider "harbor" {
  url      = var.harbor-url
  username = var.harbor-admin-username
  password = var.harbor-admin-password
  insecure = var.harbor-insecure
}
