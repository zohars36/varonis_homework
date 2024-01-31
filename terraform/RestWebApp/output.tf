output "webapp_name"{
    description = "web app name"
    value = azurerm_linux_web_app.webapp.name
}

output "webapp_managed_identity_object_id" {
  value = azurerm_linux_web_app.webapp.identity[0].principal_id
}

