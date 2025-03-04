provider "azurerm" {
  features {}
}

provider "azuread" {}

# Create a unique suffix
resource "random_integer" "apim_suffix" {
  min = 1000
  max = 9999
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-apim-oidc"
  location = var.location
}

# Create an API Management instance (Developer SKU)
resource "azurerm_api_management" "apim" {
  name                = "apimoidc${random_integer.apim_suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "Akash"
  publisher_email     = "akashdpakash@gmail.com"
  sku_name            = "Developer_1"
}

# Configure an OpenID Connect provider in APIM
resource "azurerm_api_management_openid_connect_provider" "oidc" {
  name                = "oidcprovider"
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name
  display_name        = var.oidc_display_name
  client_id           = var.oidc_client_id
  client_secret       = var.oidc_client_secret
  metadata_endpoint   = var.oidc_metadata_endpoint
}

# Publish a dummy API in APIM that returns "Hello, World!"
resource "azurerm_api_management_api" "hello_api" {
  name                = "helloapi"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Hello API"
  path                = "hello"
  protocols           = ["https"]

  import {
    content_format = "swagger-link-json"
    content_value  = var.dummy_swagger_url
  }

  # API Policy to validate JWT using OIDC and return a static response.
  policy = <<XML
<policies>
  <inbound>
    <base />
    <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized" require-expiration-time="true" require-scheme="Bearer">
      <openid-config url="${var.oidc_metadata_endpoint}" />
      <required-claims>
        <claim name="aud">
          <value>${var.oidc_audience}</value>
        </claim>
      </required-claims>
    </validate-jwt>
    <set-body template="none">Hello, World!</set-body>
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
XML
}

# (Optional) Create a service principal in Azure AD via Terraform
resource "azuread_application" "apim_app" {
  display_name = "apim-terraform-app"
}

resource "azuread_service_principal" "apim_sp" {
  application_id = azuread_application.apim_app.application_id
}

resource "random_password" "apim_sp_password" {
  length  = 32
  special = true
}

resource "azuread_service_principal_password" "apim_sp_password" {
  service_principal_id = azuread_service_principal.apim_sp.id
  value                = random_password.apim_sp_password.result
  end_date             = "2099-12-31T23:59:59Z"
}

output "apim_sp_app_id" {
  value = azuread_application.apim_app.application_id
}

output "apim_sp_client_secret" {
  value     = azuread_service_principal_password.apim_sp_password.value
  sensitive = true
}
