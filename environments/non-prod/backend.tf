terraform {
  backend "gcs" {
    bucket  = "terraform-statefile-p"
    prefix  = "non-prod/terraform/state"
  }
}
