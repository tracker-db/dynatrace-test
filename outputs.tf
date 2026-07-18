# outputs.tf
output "dashboard_id" {
  value = dynatrace_json_dashboard.basic.id
}

output "dashboard_name" {
  value = var.dashboard_name
}