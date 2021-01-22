terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.42"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group
  location = var.location
  tags = {
    "terraform" = "true"
  }
}

module "application" {
  source            = "./modules/function"
  resource_group    = var.resource_group
  location          = var.location
  application_name  = var.application_name

  database_url      = module.database.database_url
  database_username = module.database.database_username
  database_password = module.database.database_password

  depends_on = [
    module.database,
    azurerm_resource_group.main
  ]
}

module "database" {
  source           = "./modules/mysql"
  resource_group   = var.resource_group
  location         = var.location
  application_name = var.application_name
  depends_on = [
    azurerm_resource_group.main
  ]
}
