variable "location" {
  type        = string
  description = "The region for the deployment"
  default     = "West Europe"
}

locals{
  name = "RestAppInfraVar"
  resourcegroup_name = "${local.name}RG"
  storage_acc_name = lower("${local.name}sta")
  key_vault_name = lower("${local.name}kv")

  common_tags = {
    env_type = "config"
  }
}