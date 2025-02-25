variable "keycloak_url" {
  type        = string
  description = "Keycloak URL"
}

variable "keycloak_username" {
  type        = string
  description = "Keycloak Admin User"
  sensitive   = true
}

variable "keycloak_password" {
  type        = string
  description = "Keycloak Admin Password"
  sensitive   = true
}

variable "keycloak_insecure" {
  type        = bool
  description = "Use insecure connection"
  default     = false
}

variable "client_id" {
  type        = string
  description = "Keycloak Client ID"
}

variable "client_secret" {
  type        = string
  description = "Keycloak Client Secret"
  sensitive   = true
}

variable "client_uris" {
  type    = list(string)
  default = ["us-west-1a"]
}

