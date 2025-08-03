variable "location" {
  description = "Azure region"
  default     = "West Europe"
  type        = string
}

variable "db_password" {
  description = "PostgreSQL admin password"
  type        = string
  sensitive   = true
}
variable "resource_group" {
  description = "resource group name"
  default     = "shobi-rg"
  type        = string
}

variable "vnet" {
  description = "Vnet name"
  type        = string

}

variable "public_subnet" {
  type = string
}

variable "private_subnet" {
  type = string
}
variable "acr_name" {
  description = "The name of the Azure Container Registry (must be globally unique)"
  type        = string
}

variable "appservice_plan" {
  type = string
}

variable "webapp" {
  type = string
}

variable "postgres" {
  type = string
}

variable "location2" {
  type = string
}
  