output "dashboard_ids" {
  description = "The IDs of the generated Executive Overview dashboards"
  value = {
    for k, mod in module.vault_dashboard : k => mod.overview_dashboard_id
  }
}
