// ----------------------------------------------------
// Required Variables
// ----------------------------------------------------
variable "gcp_project" {
  description = "The name of the GCP project to use"
  type        = string
}

variable "cluster_name" {
  description = "Name of the K8s cluster to create"
  type        = string
}

variable "zone" {
  description = "Zone in which to create the cluster"
  type        = string
}

// ----------------------------------------------------
// Optional Variables
// ----------------------------------------------------
variable "node_machine_type" {
  description = "Node type for the K8s cluster"
  type        = string
  default     = "n1-standard-2"
}

variable "jenkins_x_namespace" {
  description = "The K8s namespace to install Jenkins X into"
  type        = string
  default     = "jx"
}
