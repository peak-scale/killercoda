variable "tenant_name" {
  type = string
}

variable "namespaces" {
  type = list(string)
}

variable "quota" {
  type = map(string)
}

variable "permissions" {
  type = list(object({
    name = string
    kind = string
    role = string
  }))

  validation {
    condition     = alltrue([for p in var.permissions : p.role == "read-only" || p.role == "owner" || p.role == "administrator"])
    error_message = "Each role must be one of the following: read-only, owner, administrator."
  }
}