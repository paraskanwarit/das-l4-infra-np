provider "google" {
  project = var.project_id
  region  = "australia-southeast1"
}

module "cloudsql" {
  source           = "git::https://github.com/paraskanwarit/terraform-modules.git//cloudsql?ref=v1.0.0-beta"
  instance_name    = "dev-sql-instance"
  database_version = "POSTGRES_16"
  region           = "australia-southeast1"
  tier             = "db-perf-optimized-N-2"
  availability_type = "REGIONAL"
  disk_size        = 50
  disk_type        = "PD_SSD"
  ipv4_enabled     = false
  private_network  = var.private_network
  authorized_networks = []
  root_password    = var.sql_root_password
  db_user          = "devuser"
  db_password      = var.sql_app_password
  db_name          = "devdb"
  labels = {
    environment = "dev"
    owner       = "team"
  }
}
#test 1