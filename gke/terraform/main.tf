// ----------------------------------------------------------------------------
// Enforce Terraform version
//
// Using pessemistic version locking for all versions 
// ----------------------------------------------------------------------------
terraform {
  required_version = "~> 0.12.0"
}

// ----------------------------------------------------------------------------
// Configure providers
// ----------------------------------------------------------------------------
provider "google" {
  version = "~> 3.10"
  project = var.gcp_project
  zone    = var.zone
}

provider "google-beta" {
  version = "~> 3.10"
  project = var.gcp_project
  zone    = var.zone
}

provider "random" {
  version = "~> 2.2"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

data "google_client_config" "default" {
}

provider "kubernetes" {
  version          = "~> 1.11"
  load_config_file = false

  host  = "https://${module.cluster.cluster_endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    module.cluster.cluster_ca_certificate,
  )
}


// ----------------------------------------------------------------------------
// Enable all required GCloud APIs
//
// https://www.terraform.io/docs/providers/google/r/google_project_service.html
// ----------------------------------------------------------------------------
resource "google_project_service" "cloudresourcemanager_api" {
  provider           = google
  project            = var.gcp_project
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute_api" {
  provider           = google
  project            = var.gcp_project
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam_api" {
  provider           = google
  project            = var.gcp_project
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudbuild_api" {
  provider           = google
  project            = var.gcp_project
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "containerregistry_api" {
  provider           = google
  project            = var.gcp_project
  service            = "containerregistry.googleapis.com"
  disable_on_destroy = false
}

// ----------------------------------------------------------------------------
// Create cluster
// ----------------------------------------------------------------------------
module "cluster" {
  source = "./modules/cluster"

  gcp_project         = var.gcp_project
  zone                = var.zone
  cluster_name        = var.cluster_name
  jenkins_x_namespace = var.jenkins_x_namespace

  node_machine_type = var.node_machine_type
}

# // ----------------------------------------------------------------------------
# // Setup service accounts
# // ----------------------------------------------------------------------------
# module "sa" {
#   source = "./modules/sa"

#   gcp_project         = var.gcp_project
#   cluster_name        = var.cluster_name
#   jenkins_x_namespace = var.jenkins_x_namespace
# }

// ----------------------------------------------------------------------------
// Let's generate jx-requirements.yml 
// ----------------------------------------------------------------------------
resource "local_file" "jx-requirements" {
  depends_on = [
  ]
  content = templatefile("${path.module}/jx-requirements.yml.tpl", {
    cluster_name           = var.cluster_name
    region                 = regex("[a-z]+-[a-z]+", var.zone)
    log_storage_url        = module.cluster.log_storage_url
    report_storage_url     = module.cluster.report_storage_url
    repository_storage_url = module.cluster.repository_storage_url

    # create_vault_resources      = var.create_vault_resources
    # vault_kms_key               = var.create_vault_resources ? aws_kms_key.kms_vault_unseal[0].id : null
    # vault_bucket                = var.create_vault_resources ? aws_s3_bucket.vault-unseal-bucket[0].id : null
    # vault_dynamodb_table        = var.create_vault_resources ? aws_dynamodb_table.vault-dynamodb-table[0].id : null
    # vault_user                  = var.vault_user
    # enable_external_dns         = var.enable_external_dns
    # domain                      = trimprefix(join(".", [var.subdomain, var.apex_domain]), ".")
    # enable_tls                  = var.enable_tls
    # tls_email                   = var.tls_email
    # use_production_letsencrypt  = var.production_letsencrypt
  })
  filename = "${path.module}/jx-requirements.yml"
}

// ----------------------------------------------------------------------------
// Let's make sure `jx boot` can connect to the cluster by writing a kubeconfig
// ----------------------------------------------------------------------------
resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${module.cluster.cluster_name} --zone=${module.cluster.cluster_location}"
  }
}
