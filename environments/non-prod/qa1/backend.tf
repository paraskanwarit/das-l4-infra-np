terraform {
  backend "gcs" {
    bucket  = "terraform-statefile-p"
    prefix  = "qa1/terraform/state"
  }
} 