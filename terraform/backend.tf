terraform {
  backend "azurerm" {
    resource_group_name   = "hcl"
    storage_account_name  = "hellobayerstorage"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
