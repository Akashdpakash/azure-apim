output "apim_gateway_url" {
  description = "The gateway URL of the API Management instance."
  value       = azurerm_api_management.apim.gateway_url
}

output "hello_api_url" {
  description = "The URL of the published Hello API. Append '/hello' to test."
  value       = "${azurerm_api_management.apim.gateway_url}/hello"
}
