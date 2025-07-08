provider "google" {
  project = var.project_id
  region  = "australia-southeast1"
}

module "cloudsql" {
  source           = "/Users/paraskanwar/Documents/paras-work/das-l4-infra-np/environments/non-prod/dev"
  instance_name    = "qv-testing-sql-instance"
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
  db_user          = "qv-testinguser"
  db_password      = var.sql_app_password
  db_name          = "qv-testingdb"
  labels = {
    environment = "qv-testing"
    owner       = "team"
  }
}
