# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = local.resourcegroup_name
  location = var.location

  tags = local.common_tags
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "${local.name}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"

  tags = local.common_tags
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = "${local.name}-webapp"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
    
  identity {
    type = "SystemAssigned"
  }

  site_config {   
    application_stack {
      python_version = "3.12"      
    }
    minimum_tls_version = "1.2"
  }
  app_settings = {    
    AZURE_TABLE_CONN_STRING = "@Microsoft.KeyVault(SecretUri=https://${local.key_vault_name}.vault.azure.net/secrets/table-conn-string/)"    
  }

  tags = local.common_tags
}

resource "azurerm_role_assignment" "keyvault_role" {
  depends_on = [azurerm_linux_web_app.webapp]

  scope                = "${local.key_vault_scope}"
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.webapp.identity[0].principal_id
}
