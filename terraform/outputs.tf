output "app_service_url" {
  description = "URL of the deployed Web App"
  value       = "https://${azurerm_linux_web_app.webapp.default_hostname}"
}


output "postgresql_fqdn" {
  description = "PostgreSQL Server FQDN"
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "public_ip_address" {
  description = "Load Balancer Public IP"
  value       = azurerm_public_ip.lb_ip.ip_address
}
output "acr_login_server" {
  description = "The login server of the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  description = "The admin username for ACR"
  value       = azurerm_container_registry.acr.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "The admin password for ACR"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}
 