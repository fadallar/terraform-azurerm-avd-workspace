# TODO: Please modify main.ft file. 
# All inputs for modules must be defined in locals or referenced from related module outputs. 
# Try to avoid to use shared resources and add modules which are mandatory for test.

# Please specify local values
locals {
  #custom_name         = ""
  stack               = "avdpoc"
  landing_zone_slug   = "sbx"
  location            = "westeurope"
  resource_group_name = "testavdpoc"

  # specify extra tags value if needed
  extra_tags = {
    tag1 = "FirstTag",
    tag2 = "SecondTag"
  }

  # specify base tagging values
  environment     = "sbx"
  application     = "avd"
  cost_center     = "CCT"
  change          = "CHG666"
  owner           = "Fabrice"
  spoc            = "Fabrice"
  tlp_colour      = "WHITE"
  cia_rating      = "C1I1A1"
  technical_owner = "Fabrice"

  # AVD Workspace
  avd_workspace_friendly_name    = "Myworkspcace"
  avd_workspace_description      = "My description"
  avd_workspace_private_endpoint = false
}

module "regions" {
  source       = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-regions//module?ref=master"
  azure_region = local.location
}

module "base_tagging" {
  source          = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-basetagging//module?ref=master"
  environment     = local.environment
  application     = local.application
  cost_center     = local.cost_center
  change          = local.change
  owner           = local.owner
  spoc            = local.spoc
  tlp_colour      = local.tlp_colour
  cia_rating      = local.cia_rating
  technical_owner = local.technical_owner
}

module "resource_group" {
  source            = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-resourcegroup//module?ref=master"
  stack             = local.stack
  landing_zone_slug = local.landing_zone_slug
  default_tags      = module.base_tagging.base_tags
  location          = module.regions.location
  location_short    = module.regions.location_short
}

module "diag_log_analytics_workspace" {
  source = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-loganalyticsworkspace//module?ref=feature/use-tf-lock-file"

  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  location            = module.regions.location
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name
  default_tags        = module.base_tagging.base_tags

}

# Please specify source as git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git<<ADD_MODULE_NAME>>//module?ref=master or with specific tag
module "avdworkspace" {
  source = "../../module"
  #custom_name         = local.custom_name
  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  location            = module.regions.location
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name
  # Default Tags
  default_tags = module.base_tagging.base_tags
  # Extra Tags
  extra_tags                      = local.extra_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id

  # Module Parameters
  friendly_name           = local.avd_workspace_friendly_name
  description             = local.avd_workspace_description
  enable_private_endpoint = local.avd_workspace_private_endpoint
}