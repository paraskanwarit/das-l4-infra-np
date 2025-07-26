# GKE Autopilot Cluster Configuration
# This file provisions a GKE Autopilot cluster for the dev environment

# GKE Autopilot Cluster
module "gke_autopilot" {
  source = "github.com/paraskanwarit/terraform-modules//gke-autopilot"

  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  network    = var.network
  subnetwork = var.subnetwork

  release_channel = var.release_channel

  master_authorized_networks = var.master_authorized_networks
}

# Outputs for use by other modules (like flux-bootstrap)
output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.gke_autopilot.name
}

output "cluster_endpoint" {
  description = "The IP address of the cluster master"
  value       = module.gke_autopilot.endpoint
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate (base64 encoded)"
  value       = module.gke_autopilot.ca_certificate
  sensitive   = true
}

output "cluster_id" {
  description = "The ID of the GKE cluster"
  value       = module.gke_autopilot.id
} 