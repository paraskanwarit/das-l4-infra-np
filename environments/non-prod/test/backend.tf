terraform {
  backend "gcs" {
    bucket  = "terraform-statefile-p"
    prefix  = "test/terraform/state"
  }
}
