terraform {
  backend "gcs" {
    bucket  = "terraform-statefile-p"
    prefix  = "qa2/terraform/state"
  }
}
