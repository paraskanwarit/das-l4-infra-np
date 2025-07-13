# Test resource for destroy workflow testing
resource "google_storage_bucket" "test_bucket" {
  name          = "test-destroy-bucket-${random_string.bucket_suffix.result}"
  location      = "australia-southeast1"
  force_destroy = true  # Allow destruction even if not empty

  labels = {
    environment = "dev"
    purpose     = "testing"
    owner       = "team"
  }
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
} 