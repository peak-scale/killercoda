variable "harbor_username" {
  type        = string
  description = "api user"
  default     = "admin"
}
variable "harbor_password" {
  type        = string
  description = "the password of the api user"
  default     = "Harbor12345"
}

variable "harbor_url" {
  type        = string
  description = "The url of the artifacts repository"
}

variable "harbor_insecure" {
  type        = bool
  description = "Use insecure connection"
  default     = true
}
