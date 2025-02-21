variable "harbor-admin-username" {
  type        = string
  description = "api user"
  default     = "admin"
}
variable "harbor-admin-password" {
  type        = string
  description = "the password of the api user"
  default     = "Harbor12345"
}

variable "harbor-url" {
  type        = string
  description = "The url of the artifacts repository"
}

variable "harbor-insecure" {
  type        = bool
  description = "Use insecure connection"
  default     = true
}
