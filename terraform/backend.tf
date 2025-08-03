terraform {
  backend "azurerm" {
    resource_group_name  = "shobi-rg"
    storage_account_name = "storageshobi"
    container_name       = "containersh"
    key                  = "dev.terraform.tfstate"
  }
}


