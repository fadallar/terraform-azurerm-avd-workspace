# Add Checkov skips here, if required.

resource "azurerm_virtual_desktop_workspace" "this" {
  name                = local.name
  location            = var.location
  resource_group_name = var.resource_group_name

  description   = var.description
  friendly_name = var.friendly_name
  tags          = merge(var.default_tags, var.extra_tags)
}