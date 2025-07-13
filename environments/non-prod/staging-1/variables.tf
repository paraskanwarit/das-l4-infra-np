variable "private_network" {
  description = "The VPC network self link for PSC."
  type        = string
}

variable "sql_root_password" {
  description = "Root password for CloudSQL."
  type        = string
  sensitive   = true
}

variable "sql_app_password" {
  description = "App user password for CloudSQL."
  type        = string
  sensitive   = true
}
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

