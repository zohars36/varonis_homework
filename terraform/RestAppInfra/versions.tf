# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.89.0"
    }
  }

    backend "azurerm" {
    resource_group_name = "CommonInfra"
    storage_account_name = "commoninfravarsa"
    container_name = "tfstates"
    key = "common.infra.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}
