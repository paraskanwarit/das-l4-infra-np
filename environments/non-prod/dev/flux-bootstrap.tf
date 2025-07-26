# FluxCD Bootstrap Configuration
# This file installs FluxCD on the GKE cluster after the cluster is ready

# Data source to get cluster information
data "google_container_cluster" "gke" {
  name     = module.gke_autopilot.name
  location = var.region
  project  = var.project_id

  depends_on = [module.gke_autopilot]
}

# Provider configuration for Helm
provider "helm" {
  kubernetes = {
    host                   = data.google_container_cluster.gke.endpoint
    cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}

# Get current Google client configuration for authentication
data "google_client_config" "current" {}

# FluxCD Installation
resource "helm_release" "flux" {
  name       = "flux"
  repository = "https://fluxcd-community.github.io/helm-charts"
  chart      = "flux2"
  version    = var.flux_version
  namespace  = "flux-system"
  create_namespace = true

  set = [
    {
      name  = "installCRDs"
      value = "true"
    },
    {
      name  = "watchAllNamespaces"
      value = "true"
    },
    {
      name  = "networkPolicy.create"
      value = "true"
    },
    {
      name  = "metrics.enabled"
      value = "true"
    },
    {
      name  = "events.enabled"
      value = "true"
    }
  ]

  depends_on = [data.google_container_cluster.gke]
}

# Output FluxCD installation status
output "flux_installed" {
  description = "FluxCD installation status"
  value       = helm_release.flux.status
}

output "flux_namespace" {
  description = "FluxCD namespace"
  value       = helm_release.flux.namespace
} 