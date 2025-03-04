variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "eastus"
}

variable "oidc_display_name" {
  description = "Display name for the OIDC provider"
  type        = string
  default     = "Example OIDC Provider"
}

variable "oidc_client_id" {
  description = "Client ID for the OIDC provider"
  type        = string
}

variable "oidc_client_secret" {
  description = "Client Secret for the OIDC provider"
  type        = string
}

variable "oidc_metadata_endpoint" {
  description = "Metadata endpoint URL for the OIDC provider (e.g., https://login.microsoftonline.com/<tenant>/v2.0/.well-known/openid-configuration)"
  type        = string
}

variable "oidc_audience" {
  description = "Expected audience claim value in the JWT token"
  type        = string
}

variable "dummy_swagger_url" {
  description = "Dummy Swagger (OpenAPI) definition URL for API import"
  type        = string
  default     = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-apim-create/api.json"
}
