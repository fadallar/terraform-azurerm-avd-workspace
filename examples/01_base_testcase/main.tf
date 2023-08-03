# TODO: Please modify main.ft file. 
# All inputs for modules must be defined in locals or referenced from related module outputs. 
# Try to avoid to use shared resources and add modules which are mandatory for test.

# Please specify local values
locals {
  stack             = "avdpoc"
  landing_zone_slug = "sbx"
  location          = "westeurope"

  # 
  extra_tags = {
    tag1 = "FirstTag",
    tag2 = "SecondTag"
  }

  # base tagging values
  environment     = "sbx"
  application     = "terra-module"
  cost_center     = "CCT"
  change          = "CHG666"
  owner           = "Fabrice"
  spoc            = "Fabrice"
  tlp_colour      = "WHITE"
  cia_rating      = "C1I1A1"
  technical_owner = "Fabrice"

  # AVD Workspace
  avd_workspace_friendly_name    = "My friendly name"
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
  source                          = "../../module"
  landing_zone_slug               = local.landing_zone_slug
  stack                           = local.stack
  location                        = module.regions.location
  location_short                  = module.regions.location_short
  resource_group_name             = module.resource_group.resource_group_name
  default_tags                    = module.base_tagging.base_tags
  extra_tags                      = local.extra_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id

  # Module Parameters
  friendly_name           = local.avd_workspace_friendly_name
  description             = local.avd_workspace_description
  enable_private_endpoint = local.avd_workspace_private_endpoint
}