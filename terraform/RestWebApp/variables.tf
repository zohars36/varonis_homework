
variable "env_type" {
  type        = string
  description = "env type"
  default     = "Dev"
}

variable "instance_no" {
  type        = string
  description = "instance number"
  default     = "1"
}

variable "location" {
  type        = string
  description = "The region for the deployment"
  default     = "West Europe"
}

variable "subscription" {
  type        = string
  description = "The subscriptions"
  default     = "dffea7c2-6ec7-4e2d-8ba9-0f25e0809566"
}

variable "key_vault_rg" {
  type        = string
  description = "The key vault resource group"
  default     = "RestRG"
}

locals{
  name = "rest${var.env_type}no${var.instance_no}"
  resourcegroup_name = "${local.name}rg"
  key_vault_name = data.terraform_remote_state.common_infra_remote.outputs.key_vault_name
  infra_subscription = data.terraform_remote_state.common_infra_remote.outputs.infra_subscription
  key_vault_rg = data.terraform_remote_state.common_infra_remote.outputs.key_vault_rg
  key_vault_scope = "/subscriptions/${local.infra_subscription}/resourceGroups/${local.key_vault_rg}/providers/Microsoft.KeyVault/vaults/${local.key_vault_name}"
  
  common_tags = {
    env_type = var.env_type
    instance_no = var.instance_no
  }
}