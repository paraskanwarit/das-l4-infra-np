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

# NOTE: Applications should use Workload Identity Federation to connect to this CloudSQL instance.
# See: https://cloud.google.com/sql/docs/postgres/connect-workload-identity for setup and IAM guidance.
# Do NOT store DB credentials in app code. Use IAM roles and GCP service accounts for secure access.
