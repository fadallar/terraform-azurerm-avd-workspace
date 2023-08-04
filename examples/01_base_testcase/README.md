# AVD Workspace - Base test case

This is an example for setting-up a an Azure Virtual Desktop Workspace with an AVD Application Group association

This test case:
- Sets the different Azure Region representation (location, location_short, location_cli ...) --> module "regions"
- Instanciates a map object with the common Tags ot be applied to all resources --> module "base_tagging"
- Creates the following module dependencies
    - Resource Group
    - Log Analytics workspace
    - AVD Host Pool
    - AVD App Group
- Creates an Azure Virtual Desktop Workspace --> module "avd_workspace" which also
    - Set the default diagnostics settings (All Logs and metric) whith the previously confuigured Log Analytics workspace as destination
    - Associate the Workspace with the previously created AVD App Group
<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->

<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
