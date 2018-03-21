#	Copyright 2018, Google, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# GCP Region: 
REGION=asia-southeast1
# GCP Zone to provision GKE Cluster
ZONE=asia-southeast1-a
# Get the billing account with the command: `gcloud alpha billing accounts list`
GCP_BILLING_ACCOUNT=0X0X0X-0X0X0X-0X0X0X

# TERRAFORM
# This is the service account user: 
TF_ADMIN_USER=terraform-admin
# The service account credential will be saved here:
TF_CREDENTIAL=~/.gcp/$(TF_ADMIN_USER).json
# Change this to your correct Project ID
TF_PROJECT_ID=$(USER)-terraform

# GKE_CLUSTER_NAME
GKE_CLUSTER_NAME=demo

echo-vars:
	echo $(PROJECT_ID)
	echo $(ZONE)
	echo $(GKE_SA)
	echo $(GKE_SA_EMAIL)
	echo $(TF_ADMIN_USER)
	echo $(TF_CREDENTIAL)
	echo $(TF_PROJECT_ID)

install:
	gcloud services enable iam.googleapis.com
	gcloud services enable cloudresourcemanager.googleapis.com
	gcloud services enable compute.googleapis.com
	gcloud services enable container.googleapis.com
	gcloud iam service-accounts create $(TF_ADMIN_USER) --project $(TF_PROJECT_ID) --display-name "Terraform admin service account"
	gcloud iam service-accounts keys create $(TF_CREDENTIAL) --iam-account $(TF_ADMIN_USER)@$(TF_PROJECT_ID).iam.gserviceaccount.com
	gcloud projects add-iam-policy-binding $(TF_PROJECT_ID) --member serviceAccount:$(TF_ADMIN_USER)@$(TF_PROJECT_ID).iam.gserviceaccount.com --role roles/owner
	wget https://releases.hashicorp.com/terraform/0.11.4/terraform_0.11.4_linux_amd64.zip
	unzip terraform_0.11.4_linux_amd64.zip

create-service-account:
	gcloud iam service-accounts create $(TF_ADMIN_USER) --project $(TF_PROJECT_ID) --display-name "Terraform admin service account"
	gcloud iam service-accounts keys create $(TF_CREDENTIAL) --iam-account $(TF_ADMIN_USER)@$(TF_PROJECT_ID).iam.gserviceaccount.com
	gcloud projects add-iam-policy-binding $(TF_PROJECT_ID) --member serviceAccount:$(TF_ADMIN_USER)@$(TF_PROJECT_ID).iam.gserviceaccount.com --role roles/owner

delete-service-account:
	gcloud iam service-accounts delete $(TF_ADMIN_USER)@$(TF_PROJECT_ID).iam.gserviceaccount.com --project $(TF_PROJECT_ID)
	rm -f $(TF_CREDENTIAL)

enable-apis:
	gcloud services enable iam.googleapis.com
	gcloud services enable cloudresourcemanager.googleapis.com
	gcloud services enable compute.googleapis.com
	gcloud services enable container.googleapis.com

install-terraform:
	wget https://releases.hashicorp.com/terraform/0.11.4/terraform_0.11.4_linux_amd64.zip
	unzip terraform_0.11.4_linux_amd64.zip

delete-terraform:
	rm -f terraform_0.11.4_linux_amd64.zip
	rm -f terraform

terraform-plan:
	cd tf/; ../terraform init 
	cd tf/; ../terraform plan 

terraform-apply:
	cd tf/; ../terraform apply

terraform-destroy:
	cd tf/; ../terraform destroy

create-project:
	gcloud projects create ${TF_PROJECT_ID}
	gcloud beta billing projects link ${TF_PROJECT_ID} --billing-account $(GCP_BILLING_ACCOUNT)

configure-kubectl-creds:
	gcloud container clusters get-credentials $(GKE_CLUSTER_NAME) --zone $(ZONE)

