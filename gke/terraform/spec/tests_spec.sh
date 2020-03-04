Describe "GCloud"
  Describe "Services"
   It "All required services are enabled"
    When call gcloud services list --enabled
    The output should include cloudresourcemanager.googleapis.com
    The output should include compute.googleapis.com
    The output should include iam.googleapis.com
    The output should include cloudbuild.googleapis.com
   End
  End

  Describe "IAM"
    iam() {
      gcloud projects get-iam-policy $(terraform output gcp_project) --format json | jq '.bindings[] | select(.role == "roles/'$1'").members[]'
    }

    It "Storage service account has the storage.objectAdmin role"
      When call iam storage.objectAdmin
      The output should include "serviceAccount:$(terraform output cluster_name)-storage@$(terraform output gcp_project).iam.gserviceaccount.com"
    End

    It "Kaniko service account has the storage.admin role"
      When call iam storage.admin
      The output should include "serviceAccount:$(terraform output cluster_name)-kaniko@$(terraform output gcp_project).iam.gserviceaccount.com"
    End

    It "jxboot service account has the dns.admin role"
      When call iam dns.admin
      The output should include "serviceAccount:$(terraform output cluster_name)-jxboot@$(terraform output gcp_project).iam.gserviceaccount.com"
    End

    It "jxboot service account has the viewer role"
      When call iam viewer
      The output should include "serviceAccount:$(terraform output cluster_name)-jxboot@$(terraform output gcp_project).iam.gserviceaccount.com"
    End

    It "jxboot service account has the viewer role"
      When call iam iam.serviceAccountKeyAdmin
      The output should include "serviceAccount:$(terraform output cluster_name)-jxboot@$(terraform output gcp_project).iam.gserviceaccount.com"
    End

    It "jxboot service account has the viewer role"
      When call iam storage.admin
      The output should include "serviceAccount:$(terraform output cluster_name)-jxboot@$(terraform output gcp_project).iam.gserviceaccount.com"
    End
  End
End

Describe "K8s"
  Describe "Service Accounts"
    sa() {
      kubectl get sa $1 -n jx -o json | jq -r '.metadata.annotations["iam.gke.io/gcp-service-account"]'
    }

    It "Kaniko service account has workload identity annotation"
      When call sa kaniko-sa
      The output should eq "$(terraform output cluster_name)-kaniko@$(terraform output gcp_project).iam.gserviceaccount.com"
    End

    It "Tekton service account has workload identity annotation"
      When call sa tekton-bot
      The output should eq "$(terraform output cluster_name)-storage@$(terraform output gcp_project).iam.gserviceaccount.com"
    End

    It "Build controller service account has workload identity annotation"
      When call sa jenkins-x-controllerbuild
      The output should eq "$(terraform output cluster_name)-storage@$(terraform output gcp_project).iam.gserviceaccount.com"
    End
  End

  Describe "Workload Identity"
    workload_idenity() {
      kubectl run --rm -it --generator=run-pod/v1 --image google/cloud-sdk:slim --serviceaccount $1 --namespace jx workload-identity-test-$1 -- gcloud auth list 2>&1
    }

    It "Pod with Kaniko service account uses workload idenity"
      When call workload_idenity kaniko-sa
      The output should include "$(terraform output cluster_name)-kaniko@$(terraform output gcp_project).iam.gserviceaccount.com"
    End

    It "Pod with Tekton service account uses workload idenity"
      When call workload_idenity tekton-bot
      The output should include "$(terraform output cluster_name)-storage@$(terraform output gcp_project).iam.gserviceaccount.com"
    End

    It "Pod with BouldController service account uses workload idenity"
      When call workload_idenity jenkins-x-controllerbuild
      The output should include "$(terraform output cluster_name)-storage@$(terraform output gcp_project).iam.gserviceaccount.com"
    End
  End

  Describe "Storage"
    It "Log storage has been created"
      When call gsutil ls $(terraform output log_storage_url)
      The status should be success
    End

    It "Reports storage has been created"
      When call gsutil ls $(terraform output report_storage_url)
      The status should be success
    End    

    It "Repository storage has been created"
      When call gsutil ls $(terraform output repository_storage_url)
      The status should be success
    End
  End  
End
