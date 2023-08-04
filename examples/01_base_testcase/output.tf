# TODO: Add all outputs from outputs.tf file inside module folder

output "avdworkspace" {
  description = "Description"
  value       = module.avd_workspace
  sensitive   = false
}