
variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region to use."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "stack" {
  description = "Project stack name."
  type        = string
  validation {
    condition     = var.stack == "" || can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.stack))
    error_message = "Invalid variable: ${var.stack}. Variable name must start with a lowercase letter, end with an alphanumeric lowercase character, and contain only lowercase letters, digits, or a dash (-)."
  }
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