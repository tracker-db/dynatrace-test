output "overview_dashboard_id" {
  description = "The ID of the Executive Overview dashboard"
  value       = dynatrace_document.vault_overview.id
}

output "overview_dashboard_name" {
  value = dynatrace_document.vault_overview.name
}
