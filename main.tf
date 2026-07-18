# main.tf
resource "dynatrace_json_dashboard" "basic" {
  dashboard = jsonencode({
    name = var.dashboard_name
    tiles = [
      {
        name      = "Notes"
        tileType  = "TEXT"
        bounds    = { x = 0, y = 0, width = 6, height = 3 }
        markdown  = "# Vault lab dashboard\n\nBasic test dashboard for Dynatrace Terraform.\n\nVault URL: ${var.vault_url}\nVault mount: ${var.vault_mount}\nSecret path: ${var.vault_secret_path}"
      }
    ]
  })
}