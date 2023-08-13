terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.61.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">=1.8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
  }
}
provider "azurerm" {
  features {}
}

provider "azapi" {

}

terraform {
  backend "azurerm" {}
}