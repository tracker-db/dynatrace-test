# provider.tf
provider "dynatrace" {
  env_url   = var.dynatrace_env_url
  api_token = var.dynatrace_api_token
}
