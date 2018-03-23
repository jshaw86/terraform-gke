PROJECT_ID=$(shell gcloud info --format='value(config.project)')
# GCP Region: 
REGION=asia-southeast1
# GCP Zone to provision GKE Cluster
ZONE=asia-southeast1-a
# Get the billing account with the command: `gcloud alpha billing accounts list`
GCP_BILLING_ACCOUNT=0X0X0X-0X0X0X-0X0X0X
# GKE_CLUSTER_NAME
GKE_CLUSTER_NAME=demo

# TERRAFORM
# This is the service account user: 
TF_ADMIN_USER=terraform-admin
# The service account credential will be saved here:
TF_CREDENTIAL=~/.gcp/$(TF_ADMIN_USER).json
# Change this to your correct Project ID
TF_PROJECT_ID=$(USER)-terraform
# Terraform Installer:
TF_INSTALLER=https://releases.hashicorp.com/terraform/0.11.5/terraform_0.11.5_linux_amd64.zip

export PATH := $(PWD)/bin:$(PATH)

.PHONY: help
help:
	@echo    Default variables:
	@echo    Current GCP Project ID: $(PROJECT_ID)
	@echo    Zone: $(ZONE)
	@echo    GCP Billing Account: $(GCP_BILLING_ACCOUNT)
	@echo    GKE Cluster Name: $(GKE_CLUSTER_NAME)
	@echo    Terraform Admin User: $(TF_ADMIN_USER)
	@echo    Terraform Credential Path:$(TF_CREDENTIAL)
	@echo    Terraform Project ID: $(TF_PROJECT_ID)

.PHONY: create-project
create-project:
	@gcloud projects create ${TF_PROJECT_ID}
	@gcloud beta billing projects link ${TF_PROJECT_ID} --billing-account $(GCP_BILLING_ACCOUNT)
	@gcloud config set project ${TF_PROJECT_ID}
	@gcloud config set compute/zone $(ZONE)

.PHONY: create-tf-service-account
create-tf-service-account:
	@gcloud services enable iam.googleapis.com
	@gcloud services enable cloudresourcemanager.googleapis.com
	@gcloud services enable compute.googleapis.com
	@gcloud services enable container.googleapis.com
	@gcloud iam service-accounts create $(TF_ADMIN_USER) --project $(TF_PROJECT_ID) --display-name "Terraform admin service account"
	@gcloud projects add-iam-policy-binding $(TF_PROJECT_ID) --member serviceAccount:$(TF_ADMIN_USER)@$(TF_PROJECT_ID).iam.gserviceaccount.com --role roles/owner
	@gcloud iam service-accounts keys create $(TF_CREDENTIAL) --iam-account $(TF_ADMIN_USER)@$(TF_PROJECT_ID).iam.gserviceaccount.com

.PHONY: install-tf
install-tf:
	@mkdir -p bin/
	@cd bin/; wget $(TF_INSTALLER); unzip terraform*.zip; rm -f terraform*.zip; sudo cp terraform /usr/local/bin/

.PHONY: kubectl-get-creds 
kubectl-get-creds:
	@gcloud container clusters get-credentials $(GKE_CLUSTER_NAME) --zone $(ZONE) --project $(TF_PROJECT_ID)

.PHONY: delete-service-account
delete-service-account:
	@gcloud iam service-accounts delete $(TF_ADMIN_USER)@$(TF_PROJECT_ID).iam.gserviceaccount.com --project $(TF_PROJECT_ID)
	@rm -f $(TF_CREDENTIAL)

.PHONY: delete-tf
delete-tf:
	@rm -rf bin/
	@sudo rm -f /usr/local/bin/terraform

.PHONY: delete-project
delete-project:
	@rm -rf bin/
	@sudo rm -f /usr/local/bin/terraform
	@gcloud iam service-accounts delete $(TF_ADMIN_USER)@$(TF_PROJECT_ID).iam.gserviceaccount.com --project $(TF_PROJECT_ID)
	@rm -f $(TF_CREDENTIAL)
	@gcloud projects delete ${TF_PROJECT_ID}
