terraform {
  backend "gcs" {
    bucket  = "terraform-statefile-np"
    prefix  = "qa/terraform/state"
  }
} 