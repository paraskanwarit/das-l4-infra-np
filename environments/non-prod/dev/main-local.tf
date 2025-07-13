# Override the module to fix binary_log_enabled issue for PostgreSQL
resource "google_sql_database_instance" "primary" {
  name             = "dev-sql-instance"
  database_version = "POSTGRES_16"
  region           = "australia-southeast1"

  settings {
    tier              = "db-perf-optimized-N-2"
    availability_type = "REGIONAL"
    disk_autoresize   = true
    disk_size         = 50
    disk_type         = "PD_SSD"

    backup_configuration {
      enabled    = true
      start_time = "03:00"
      # Removed binary_log_enabled for PostgreSQL compatibility
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/affable-beaker-464822-b4/global/networks/default"
    }

    maintenance_window {
      day          = 7
      hour         = 3
      update_track = "stable"
    }

    activation_policy            = "ALWAYS"
    deletion_protection_enabled = true
    user_labels = {
      environment = "dev"
      owner       = "team"
    }
  }

  deletion_protection = true
}

resource "google_sql_user" "default" {
  name     = "devuser"
  instance = google_sql_database_instance.primary.name
  password = var.sql_app_password
}

resource "google_sql_database" "default" {
  name      = "devdb"
  instance  = google_sql_database_instance.primary.name
  charset   = "utf8"
  collation = "utf8_general_ci"
} 