# AVD Workspace - Private Endpoint test case

This is an example for setting-up a an Azure Virtual Desktop Workspace with private endpoint configuration  

This test case:
- Sets the different Azure Region representation (location, location_short, location_cli ...) --> module "regions"
- Instanciates a map object with the common Tags ot be applied to all resources --> module "base_tagging"
- Creates the following module dependencies
    - Resource Group
    - VNET
    - Subnet
    - Log Analytics workspace
    - Private DNS Zone
- Creates an Azure Virtual Desktop Workspace --> module "avd_workspace" which also
    - create private endpoint  
    - Set the default diagnostics settings (All Logs and metric) whith the previously created Log Analytics workspace as destination

!! Important

Private endpoint for Azure Virtual Desktop is still a preview feature please have a look at the following link for more information  https://learn.microsoft.com/en-us/azure/virtual-desktop/private-link-setup?tabs=portal%2Cportal-2

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Main.tf file content

Please replace the modules source and version with your relevant information

```hcl
# Test case local inputs
locals {
  stack             = "avdwork-02"
  landing_zone_slug = "sbx"
  location          = "westeurope"

  # extra tags
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

  ## Networking

  virtual_network_address_space = ["10.0.0.0/16"]
  subnet_private_endpoint       = ["10.0.2.0/24"]

  # AVD Workspace
  avd_workspace_private_dns_zone = "privatelink.wvd.microsoft.com"
  avd_workspace_friendly_name    = "My friendly name"
  avd_workspace_description      = "My description"
  avd_workspace_private_endpoint = true
  avd_workspace_public_access    = "Disabled"
}

module "regions" {
  source       = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-regions//module?ref=master"
  azure_region = local.location
}

module "base_tagging" {
  source          = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-basetagging//module?ref=master"
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
  source            = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-resourcegroup//module?ref=master"
  stack             = local.stack
  landing_zone_slug = local.landing_zone_slug
  default_tags      = module.base_tagging.base_tags
  location          = module.regions.location
  location_short    = module.regions.location_short
}

module "diag_log_analytics_workspace" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-loganalyticsworkspace//module?ref=feature/master"
  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  location            = module.regions.location
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name
  default_tags        = module.base_tagging.base_tags
}

module "vnet" {
  source                          = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-vnet//module?ref=develop"
  landing_zone_slug               = local.landing_zone_slug
  stack                           = local.stack
  location                        = module.regions.location
  location_short                  = module.regions.location_short
  resource_group_name             = module.resource_group.resource_group_name
  default_tags                    = module.base_tagging.base_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id

  virtual_network_address_space           = local.virtual_network_address_space
  virtual_network_flow_timeout_in_minutes = 4
}

module "subnet_private_endpoint" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-subnet//module?ref=develop"
  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name

  virtual_network_name = module.vnet.virtual_network_name
  address_prefixes     = local.subnet_private_endpoint
  enable_delegation    = false
}

module "private_dns_zone_avd_workspace" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-privatednszone//module?ref=master"
  domain_name         = local.avd_workspace_private_dns_zone
  resource_group_name = module.resource_group.resource_group_name
  default_tags        = module.base_tagging.base_tags
  # TO-DO add VNET LINK
}

# Please specify source as git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git<<ADD_MODULE_NAME>>//module?ref=master or with specific tag
module "avd_workspace" {
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
  enable_private_endpoint    = local.avd_workspace_private_endpoint
  private_dns_zone_id        = module.private_dns_zone_avd_workspace.id
  private_endpoint_subnet_id = module.subnet_private_endpoint.subnet_id
  public_network_access      = local.avd_workspace_public_access

  friendly_name                        = local.avd_workspace_friendly_name
  description                          = local.avd_workspace_description
}
```
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_avd_workspace"></a> [avd\_workspace](#module\_avd\_workspace) | ../../module | n/a |
| <a name="module_base_tagging"></a> [base\_tagging](#module\_base\_tagging) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-basetagging//module | master |
| <a name="module_diag_log_analytics_workspace"></a> [diag\_log\_analytics\_workspace](#module\_diag\_log\_analytics\_workspace) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-loganalyticsworkspace//module | feature/master |
| <a name="module_private_dns_zone_avd_workspace"></a> [private\_dns\_zone\_avd\_workspace](#module\_private\_dns\_zone\_avd\_workspace) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-privatednszone//module | master |
| <a name="module_regions"></a> [regions](#module\_regions) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-regions//module | master |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-resourcegroup//module | master |
| <a name="module_subnet_private_endpoint"></a> [subnet\_private\_endpoint](#module\_subnet\_private\_endpoint) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-subnet//module | develop |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-vnet//module | develop |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | >=1.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.61.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |
## Resources

No resources.
## Inputs

No inputs.
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_avdworkspace"></a> [avdworkspace](#output\_avdworkspace) | outputs for avdworkspace module |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
