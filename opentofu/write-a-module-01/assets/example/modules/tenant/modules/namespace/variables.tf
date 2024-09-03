variable "tenant_name" {
  type = string
}

variable "namespace_name" {
  type = string
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
}