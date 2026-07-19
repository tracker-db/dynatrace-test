variable "env" {
  type        = string
  description = "The environment name (e.g. prod, dev)"
}

variable "service_name" {
  type        = string
  description = "The name of the service"
}

variable "dashboard_type" {
  description = "Type of dashboard to generate (external or internal)"
  type        = string
  default     = "external"
}
