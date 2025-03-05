
module "apim" {
  source              = "../modules/apim"
  apim_name           = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
}

resource "azurerm_api_management_api" "hello_api" {
  name                = "hello-api"
  resource_group_name = var.resource_group_name
  api_management_name = module.apim.apim_id
  revision            = "1"
  display_name        = "Hello API"
  path                = "hello"
  protocols           = ["https"]
}

resource "azurerm_api_management_api_operation" "hello_operation" {
  operation_id        = "sayHello"
  api_name            = azurerm_api_management_api.hello_api.name
  api_management_name = module.apim.apim_id
  resource_group_name = var.resource_group_name
  display_name        = "Say Hello"
  method              = "GET"
  url_template        = "/"
  response {
    status_code = 200
    description = "Success"
    representation {
      content_type = "application/json"
    }
  }
}
