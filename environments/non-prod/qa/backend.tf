terraform {
  backend "gcs" {
    bucket  = "terraform-statefile-p"
    prefix  = "qa/terraform/state"
  }
} 