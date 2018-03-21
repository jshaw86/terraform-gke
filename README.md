# terraform-gke
Quick Tutorial Provisioning Google Kubernetes Engine using [Terraform](https://www.terraform.io/docs/providers/google/index.html)

## Assumptions -  this tutorial assumes your already have the following:
1. A [Google Cloud Platform](https://cloud.google.com/) account.
2. Created a Project and associated to Billing. 
3. You are familiar and going to use [Google Cloud Shell](https://cloud.google.com/shell/).
4. or You have [Google Cloud SDK](https://cloud.google.com/sdk/docs/) Installed and Configured on your machine.
 
## Setup
1. Launch GCP Console, Select Project and Start Cloud Shell 
2. Clone this repo
```
git clone https://github.com/ctaguinod/terraform-gke
cd terraform-gke
```

3. Configure variables in Makefile , defaults are the following:
```
REGION=asia-southeast1
ZONE=asia-southeast1-a
TF_ADMIN_USER=terraform-admin
TF_PROJECT_ID=$(USER)-terraform
```

4. Enable apis, create terraform service account, service account json credential in ~/.gcp/ and download terraform in the current directory

Run 
```
make install
```

The command above will run the following:

```
gcloud services enable iam.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud iam service-accounts create $(TF_ADMIN_USER) --project $(TF_PROJECT_ID) --display-name "Terraform admin service account"
gcloud iam service-accounts keys create $(TF_CREDENTIAL) --iam-account $(TF_ADMIN_USER)@$(TF_PROJECT_ID).iam.gserviceaccount.com
gcloud projects add-iam-policy-binding $(TF_PROJECT_ID) --member serviceAccount:$(TF_ADMIN_USER)@$(TF_PROJECT_ID).iam.gserviceaccount.com --role roles/owner
wget https://releases.hashicorp.com/terraform/0.11.4/terraform_0.11.4_linux_amd64.zip
unzip terraform_0.11.4_linux_amd64.zip
```

5. Configure the variables and run terraform: 

Terraform configs:
* tf/iam.tf - Creates a service account with the roles storage.admin, logging.logWriter, monitoring.metricWriter and container.admin
* tf/network.tf - Creates a custom network with 3 subnetworks: cluster-net for the GKE Nodes, pod-net for Pods and svc-net for k8s services.
* tf/gke.tf - Creates a GKE cluster with the custom service acccount, custom network, ip aliases enabled, multi zone and autoscaling enabled.
* tf/terraform.tfvars - contains variables that needs to be configured:

Configure the variables in terraform.tfvars, defaults are as follows: 
```
gke_cluster_name = "demo"
project = "ctaguinod-terraform"
gke_service_account = "gke-service-account"
region = "asia-southeast1"
zone = "asia-southeast1-a"
zone2 = "asia-southeast1-b"
k8s_version = "1.8.8-gke.0"
initial_node_count = "1"
min_node_count = "1"
max_node_count = "3"
machine_type = "n1-standard-2"
disk_size_gb = "100"
cluster-net = "10.4.0.0/22"
pod-net = "10.0.0.0/14"
svc-net = "10.4.4.0/22"
```

Run the following to provision the cluster:
```
cd tf/
../terraform init
../terraform plan
../terraform apply
```

6. Verify the cluster is running:
```
gcloud container clusters list

```
Configure kubectl credentials
 
``
gcloud container clusters get-credentials $(GKE_CLUSTER_NAME) --zone $(ZONE)`
kubectl cluster-info
```

If the cluster is working you should be able to see a result similar to the ff:
```
ctaguinod@ctaguinod-terraform:~/kubernetes-demos/terraform-gke/tf$ kubectl cluster-info
Kubernetes master is running at https://35.185.180.68
GLBCDefaultBackend is running at https://35.185.180.68/api/v1/namespaces/kube-system/services/default-http-backend/proxy
Heapster is running at https://35.185.180.68/api/v1/namespaces/kube-system/services/heapster/proxy
KubeDNS is running at https://35.185.180.68/api/v1/namespaces/kube-system/services/kube-dns/proxy
kubernetes-dashboard is running at https://35.185.180.68/api/v1/namespaces/kube-system/services/kubernetes-dashboard/proxy
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
ctaguinod@ctaguinod-terraform:~/kubernetes-demos/terraform-gke/tf$
```

7. Run Sample App.

8. Clean Up.

Destroy all resource provisioned by Terraform.
```
../terraform destroy
```

Delete service account and credential
```
make delete-service-account
```

Delete Terraform
```
make delete-terraform
```


