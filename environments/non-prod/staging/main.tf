provider "google" {
  project = var.project_id
  region  = "australia-southeast1"
}

module "cloudsql" {
  source           = "../../../terraform-modules/cloudsql"
  instance_name    = "staging-sql-instance"
  database_version = "POSTGRES_14"
  region           = "australia-southeast1"
  tier             = "db-custom-2-7680"
  availability_type = "REGIONAL"
  disk_size        = 50
  disk_type        = "PD_SSD"
  ipv4_enabled     = false
  private_network  = var.private_network
  authorized_networks = []
  root_password    = var.sql_root_password
  db_user          = "staginguser"
  db_password      = var.sql_app_password
  db_name          = "stagingdb"
  labels = {
    environment = "staging"
    owner       = "team"
  }
}
