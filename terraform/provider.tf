provider "azurerm" {
  features {}
  use_msi = false
  skip_provider_registration = true

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  use_oidc        = true  # Enable OIDC authentication
}
