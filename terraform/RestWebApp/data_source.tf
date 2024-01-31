data "terraform_remote_state" "common_infra_remote" {
  backend = "azurerm"
  config = {
    resource_group_name   = "CommonInfra"
    storage_account_name   = "commoninfravarsa"
    container_name         = "tfstates"
    key                    = "common.infra.terraform.tfstate"
  }
}