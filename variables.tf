variable "dynatrace_env_url" {
  description = "dynatrace_env_url of our testing"
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

variable "automation_client_id" {
  description = "OAuth client ID for Dynatrace automation/document API"
  type        = string
}

variable "automation_client_secret" {
  description = "OAuth client secret for Dynatrace automation/document API"
  type        = string
  sensitive   = true
}

variable "automation_env_url" {
  description = "dynatrace_env_url of our automation/document API"
  type        = string
}
