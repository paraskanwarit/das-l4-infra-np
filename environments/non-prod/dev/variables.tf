variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "affable-beaker-464822-b4"
}

variable "private_network" {
  description = "Private network for CloudSQL"
  type        = string
  default     = "projects/affable-beaker-464822-b4/global/networks/default"
}

variable "sql_root_password" {
  description = "Root password for CloudSQL"
  type        = string
  sensitive   = true
}

variable "sql_app_password" {
  description = "App user password for CloudSQL"
  type        = string
  sensitive   = true
}