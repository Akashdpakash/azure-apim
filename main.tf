provider "azurerm" {
  features {}
}

provider "azuread" {}

resource "random_integer" "apim_suffix" {
  min = 1000
  max = 9999
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-apim-oidc"
  location = var.location
}

resource "azurerm_api_management" "apim" {
  name                = "apimoidc${random_integer.apim_suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "Your Publisher"
  publisher_email     = "publisher@example.com"
  sku_name            = "Developer_1"
}

resource "azurerm_api_management_openid_connect_provider" "oidc" {
  name                = "oidcprovider"
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name
  display_name        = var.oidc_display_name
  client_id           = var.oidc_client_id
  client_secret       = var.oidc_client_secret
  metadata_endpoint   = var.oidc_metadata_endpoint
}

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
