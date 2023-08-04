
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

variable "enable_application_group_association" {
  type = bool
  description = "Enable the association with an AVD Application group. If set to true an AVD App Group Id must be provide"
  default = true
}

variable "associated_application_group_id" {
  type        = string
  description = "Resource Id of the AVD application group this workspace is associated with"
  default     = null
}