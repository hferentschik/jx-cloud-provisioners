autoUpdate:
  enabled: false
  schedule: ""
terraform: true
cluster:
  clusterName: ${cluster_name}
  environmentGitOwner: ""
  provider: gke
  region: ${region}
gitops: true
environments:
  - key: dev
  - key: staging
  - key: production
storage:
  logs:
    enabled: %{ if log_storage_url != "" }true%{ else }false%{ endif }
    url: ${log_storage_url}
  reports:
    enabled: %{ if report_storage_url != "" }true%{ else }false%{ endif }
    url: ${report_storage_url}
  repository:
    enabled: %{ if repository_storage_url != "" }true%{ else }false%{ endif }
    url: ${repository_storage_url}
versionStream:
  ref: master
  url: https://github.com/jenkins-x/jenkins-x-versions.git
webhook: prow
