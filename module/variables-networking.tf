variable "public_network_access" {
  description = "Define the public network access behaviour. Possible values are Enabled, EnabledForClientsOnly ,Disabled"
  type        = string
  default     = "Enabled"
  validation {
    condition     = contains(["Disabled", "Enabled"], var.public_network_access)
    error_message = "Invalid variable: public_network_access = ${var.public_network_access}. Select valid option from list: ${join(",", ["Disabled", "Enabled"])}."
  }
}

variable "is_manual_connection" {
  description = "Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "enable_private_endpoint" {
  description = "Whether the AVD Workspace is using a private endpoint."
  type        = bool
  default     = true
}

variable "private_dns_zone_id" {
  description = "Id of the private DNS Zone to be used by AVD workspace private endpoint."
  type        = string
  default     = null
}

variable "private_endpoint_subnet_id" {
  description = "Id for the subnet used by AVD workspace private endpoint"
  type        = string
  default     = null
}