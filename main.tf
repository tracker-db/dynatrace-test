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

locals {
  environments = {
    "nextresearch"   = "https://vault.nextresearch.io/"
    "auto-deploy"    = "https://vault.auto-deploy.net/"
    "advocatediablo" = "https://vault.advocatediablo.com/"
  }
  dashboards = {
    "vault-ops-a" = "synthetics"
    "vault-ops-b" = "docker"
    "vault-ops-c" = "kubernetes"
  }
}

resource "dynatrace_http_monitor" "vault_check" {
  for_each  = local.environments
  name      = "Vault-Availability-Check (${each.key})"
  enabled   = true
  frequency = 5
  locations = ["SYNTHETIC_LOCATION-0000000000000046"]

  tags {
    tag {
      context = "CONTEXTLESS"
      key     = "service"
      value   = "vault"
    }
    tag {
      context = "CONTEXTLESS"
      key     = "env"
      value   = each.key
    }
    tag {
      context = "CONTEXTLESS"
      key     = "check_type"
      value   = "availability"
    }
  }

  script {
    request {
      url         = each.value
      method      = "GET"
      description = "Check Vault availability for ${each.key}"
    }
  }
}

resource "dynatrace_http_monitor" "vault_seal_check" {
  for_each  = local.environments
  name      = "Vault-Seal-Status-Check (${each.key})"
  enabled   = false
  frequency = 5
  locations = ["SYNTHETIC_LOCATION-0000000000000046"]

  tags {
    tag {
      context = "CONTEXTLESS"
      key     = "service"
      value   = "vault"
    }
    tag {
      context = "CONTEXTLESS"
      key     = "env"
      value   = each.key
    }
    tag {
      context = "CONTEXTLESS"
      key     = "check_type"
      value   = "seal_status"
    }
  }

  script {
    request {
      url         = "${each.value}v1/sys/health"
      method      = "GET"
      description = "Check Vault Seal Status for ${each.key}"
      
      validation {
        rule {
          type          = "httpStatusesList"
          value         = "200,429,472,473"
          pass_if_found = true
        }
      }
    }
  }
}

resource "dynatrace_http_monitor" "vault_auth_check" {
  for_each  = local.environments
  name      = "Vault-Auth-Check (${each.key})"
  enabled   = false
  frequency = 5
  locations = ["SYNTHETIC_LOCATION-0000000000000046"]

  tags {
    tag {
      context = "CONTEXTLESS"
      key     = "service"
      value   = "vault"
    }
    tag {
      context = "CONTEXTLESS"
      key     = "env"
      value   = each.key
    }
    tag {
      context = "CONTEXTLESS"
      key     = "check_type"
      value   = "auth_and_read"
    }
  }

  script {
    request {
      url         = "${each.value}v1/auth/approle/login"
      method      = "POST"
      description = "Step 1: Authenticate via AppRole"
      body        = "{\"role_id\":\"placeholder_role_id\",\"secret_id\":\"placeholder_secret_id\"}"
      
      post_processing = <<-EOT
        var response = api.getContext().response;
        if (response.getStatusCode() === 200) {
            var body = JSON.parse(response.getResponseBody());
            api.setValue("client_token", body.auth.client_token);
        }
      EOT
    }

    request {
      url         = "${each.value}v1/secret/data/monitoring"
      method      = "GET"
      description = "Step 2: Read Secret"
      
      configuration {
        headers {
          header {
            name  = "X-Vault-Token"
            value = "{client_token}"
          }
        }
      }
      
      validation {
        rule {
          type          = "httpStatusesList"
          value         = "200"
          pass_if_found = true
        }
      }
    }
  }
}

module "vault_dashboard" {
  for_each       = local.dashboards
  source         = "./modules/vault_dashboard"
  env            = each.key
  service_name   = "vault"
  dashboard_type = each.value
}
