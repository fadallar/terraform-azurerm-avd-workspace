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
- Creates an Azure Virtual Desktop Workspace --> module "avdworkspace" which also
    - create private endpoint  
    - Set the default diagnostics settings (All Logs and metric) whith a Log Analytics workspace as destination

!! Important

Private endpoint for Azure Virtual Desktop is still a preview feature please have a look at the following link for more information  https://learn.microsoft.com/en-us/azure/virtual-desktop/private-link-setup?tabs=portal%2Cportal-2

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->

<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
