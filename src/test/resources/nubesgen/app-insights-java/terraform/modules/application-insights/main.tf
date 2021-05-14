
resource "azurerm_application_insights" "insights" {
  name                = var.application_name
  location            = var.location
  resource_group_name = var.resource_group
  application_type    = "java"

  tags = {
    "environment" = var.environment
  }
}
