# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = local.resourcegroup_name
  location = var.location

  tags = local.common_tags
}

resource "azurerm_storage_account" "storage" {
  name                     = local.storage_acc_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.common_tags
}

resource "azurerm_storage_table" "table" {
  depends_on = [ azurerm_storage_account.storage ]
  name                = "restLogs"
  storage_account_name = azurerm_storage_account.storage.name
}

resource "azurerm_key_vault" "vault" {
  name                        = local.key_vault_name
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true  
  purge_protection_enabled    = false
  enable_rbac_authorization = true
}

resource "azurerm_key_vault_secret" "secret" {
  depends_on = [ azurerm_key_vault.vault, azurerm_storage_account.storage ]

  name         = "table-conn-string"  
  value        = azurerm_storage_account.storage.primary_connection_string
  key_vault_id = azurerm_key_vault.vault.id
}