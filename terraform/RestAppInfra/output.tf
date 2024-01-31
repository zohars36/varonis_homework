output "rest_storage_account_name"{
    description = "rest storage account name"
    value = azurerm_storage_account.storage.name
}
output "key_vault_name"{
    description = "key vault name"
    value = azurerm_key_vault.vault.name
}
output "key_vault_rg"{
    description = "key vault resource group"
    value = azurerm_key_vault.vault.resource_group_name
}
output "infra_subscription"{
    description = "infra subscription"
    value = data.azurerm_subscription.current.subscription_id
}
