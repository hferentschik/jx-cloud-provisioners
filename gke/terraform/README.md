# Jenkins X GKE Terraform provisioner

This directory contains a set of Terraform scripts to prepare and manage a Jenkins X Kuberenetes cluster on Google Cloud.
Running `terraform apply` will, provided all prerequisites are met, create a Kubernetes cluster on Google Cloud and create all required resources needed to then install Jenkins X via `jx boot`.

More detailed documentation around Jenkins X is available on [jenkins-x.io](https://jenkins-x.io/docs/).

<!-- MarkdownTOC autolink=true -->

- [Create Jenkins X cluster](#create-jenkins-x-cluster)
	- [Prerequisites](#prerequisites)
	- [Cluster creation](#cluster-creation)
		- [Inputs](#inputs)
		- [Outputs](#outputs)
- [Remote storage](#remote-storage)
- [Contributing](#contributing)

<!-- /MarkdownTOC -->


## Create Jenkins X cluster

### Prerequisites 

In order to run you need the following command line tools installed on your machine:

* `gcloud` ~> ?
* `terraform` ~> 0.12.0
* `kubectl` ~> ?

### Cluster creation

```bash
$ git clone https://github.com/helayoty/jx-cloud-provisioner
$ terraform init
$ terraform apply --var-file terraform.tfvars
```

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cluster\_name | Name of the K8s cluster to create | `string` | n/a | yes |
| gcp\_project | The name of the GCP project to use | `string` | n/a | yes |
| jenkins\_x\_namespace | The K8s namespace to install Jenkins X into | `string` | `"jx"` | no |
| node\_machine\_type | Node type for the K8s cluster | `string` | `"n1-standard-2"` | no |
| region | Region in which to create the cluster | `string` | n/a | yes |
| zone | Zone in which to create the cluster | `string` | n/a | yes |

#### Outputs

| Name | Description |
|------|-------------|
| cluster\_name | The name of the created Jenkins X cluster |
| cluster\_zone | The zone in which the Jenkins X cluster got created |
| gcp\_project | The name of the GCP project |
| log\_storage\_url | The bucket URL for build logs (empty if not enabled) |
| report\_storage\_url | The bucket URL for build reports (empty if not enabled) |
| repository\_storage\_url | The bucket URL for artefact repository (empty if not enabled) |

## Remote storage 

## Contributing

bla bla
