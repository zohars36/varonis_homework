# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.89.0"
    }
  }

    backend "azurerm" {
    resource_group_name = "RestRG"
    storage_account_name = "restappconfigsa"
    container_name = "tfstates"
    key = "restdevno2.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}
