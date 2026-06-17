
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.33.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = ""
  #   storage_account_name = ""
  #   container_name       = ""
  #   key                  = ""
  # }
}

provider "azurerm" {
  features {}
  subscription_id = "3b770c7c-3dd0-4873-ab89-7c5f4695e464"
}

