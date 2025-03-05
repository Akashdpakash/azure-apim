variable "apim_name" {
  description = "Name of the API Management instance"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "publisher_name" {
  description = "Name of the API publisher"
  type        = string
}

variable "publisher_email" {
  description = "Email of the API publisher"
  type        = string
}
