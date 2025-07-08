terraform {
  backend "gcs" {
    bucket  = "terraform-statefile-p"
    prefix  = "prod/terraform/state"
  }
}
