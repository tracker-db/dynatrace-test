data "vault_generic_secret" "dt" {
  path = "secret/dynatrace/automation"
}

provider "dynatrace" {
  dt_env_url               = data.vault_generic_secret.dt.data["dt_env_url"]
  dt_api_token             = data.vault_generic_secret.dt.data["dt_api_token"]
  automation_env_url       = data.vault_generic_secret.dt.data["automation_env_url"]
  automation_client_id     = data.vault_generic_secret.dt.data["client_id"]
  automation_client_secret = data.vault_generic_secret.dt.data["client_secret"]
}

resource "dynatrace_http_monitor" "vault_check" {
  name      = "Vault-Availability-Check"
  enabled   = true
  frequency = 5
  locations = ["SYNTHETIC_LOCATION-0000000000000046"]

  script {
    request {
      url         = "https://vault.nextresearch.io"
      method      = "GET"
      description = "Check Vault availability"
    }
  }
}

resource "dynatrace_document" "basic" {
  type    = "dashboard"
  name    = "vault1"
  private = false
  content = templatefile("${path.module}/dashboard.tftpl", {
    vault_monitor_id = dynatrace_http_monitor.vault_check.id
  })
}