terraform {
  backend "gcs" {
    bucket  = "terraform-statefile-p"
    prefix  = "dev/terraform/state"
  }
}
