
variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region to use."
  type        = string
}

variable "friendly_name" {
  type        = string
  description = "A friendly name for the Virtual Desktop Workspace."
  ### TO-DO add Validation Block
}

variable "description" {
  type        = string
  description = "A description for the Virtual Desktop Host Pool."
  ### TO-DO add Validation Block
}

variable "associated_application_group_id" {
  type        = string
  description = "Resource Id of the AVD application group this workspace is associated with"
  default     = null
}