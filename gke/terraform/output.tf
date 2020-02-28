output "gcp_project" {
  description = "The name of the GCP project"
  value       = var.gcp_project
}

output "cluster_name" {
  description = "The name of the created Jenkins X cluster"
  value       = module.cluster.cluster_name
}

output "cluster_zone" {
  description = "The zone in which the Jenkins X cluster got created"
  value       = module.cluster.cluster_location
}

output "log_storage_url" {
  description = "The bucket URL for build logs (empty if not enabled)"
  value       = module.cluster.log_storage_url
}

output "report_storage_url" {
  description = "The bucket URL for build reports (empty if not enabled)"
  value       = module.cluster.report_storage_url
}

output "repository_storage_url" {
  description = "The bucket URL for artefact repository (empty if not enabled)"
  value       = module.cluster.repository_storage_url
}
