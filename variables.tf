# variables.tf
variable "dynatrace_env_url" {
  description = "https://wkf10640.apps.dynatrace.com"
  type        = string
}

variable "dynatrace_api_token" {
  description = "Dynatrace API token with dashboard write permissions"
  type        = string
  sensitive   = true
}

variable "dashboard_name" {
  description = "Name for the test dashboard"
  type        = string
  default     = "vault-lab-basic-dashboard"
}

variable "vault_url" {
  description = "HashiCorp Vault URL"
  type        = string
  default     = ""
}

variable "vault_mount" {
  description = "Vault mount path for the test secret"
  type        = string
  default     = "secret"
}

variable "vault_secret_path" {
  description = "Vault secret path to validate"
  type        = string
  default     = "lab/test"
}