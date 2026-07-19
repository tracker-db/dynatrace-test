resource "dynatrace_document" "vault_overview" {
  type    = "dashboard"
  name    = var.env
  private = false
  content = templatefile("${path.module}/dashboard_${var.dashboard_type}.tftpl", {
    env            = var.env
    service_name   = var.service_name
    dashboard_name = var.env
  })
}
