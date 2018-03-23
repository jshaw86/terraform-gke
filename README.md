# terraform-gke
Quick guide to provision [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/) using [Terraform](https://www.terraform.io/docs/providers/google/index.html)

## Before you begin.

This guide assumes that:

1. You are already familiar with and have a [Google Cloud Platform](https://cloud.google.com/) account.
2. You are already familiar with [Kubernetes](https://kubernetes.io/). If you are looking for a basic tutorial, here's a good [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/) tutorial. 
3. You are already familiar with [Terraform](https://www.terraform.io/). If you are looking for a detailed tutorial, here's a good [Introduction to Terraform](https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180) tutorial.
4. [Google Cloud Shell](https://cloud.google.com/shell/) will be used.
 
## Setup

1. Start Cloud Shell. 

2. Clone this repo.
```
git clone https://github.com/ctaguinod/terraform-gke
cd terraform-gke
```

3. Modify the variables configured in the file `Makefile`.

Default variables are as follows: 

```
REGION=asia-southeast1
ZONE=asia-southeast1-a
TF_ADMIN_USER=terraform-admin
TF_PROJECT_ID=$(USER)-terraform
```

4. Create New Project: Run: `make create-project` , skip this step if you already have a project created and associated to billing.

5. Create Service Account: Run: `make create-tf-service-account`.

6. Install Terraform binary: Run: `make install-tf` , skip this step if you already have terraform installed.

7. Modify the variables in the file `terraform/terraform.tfvars`

Default variables are as follows:

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

8. Run Terraform Commands inside `terraform/` directory to provision the infrastructure:

`cd terraform/`

To Initialize Terraform Run: `terraform init`.

To Generate execution plan for Terraform Run: `terraform plan`.

To Build / Execute the Terraform plan Run: `terraform apply`.

`cd ..`

9. Configure kubectl credential, Run: `make kubectl-get-creds`.

10. Verify if the cluster works, Run: `kubectl cluster-info`.

If kubectl can connect to the cluster and If the cluster is working you should be able to see a result similar to the ff:
```
Kubernetes master is running at https://35.185.180.68
GLBCDefaultBackend is running at https://35.185.180.68/api/v1/namespaces/kube-system/services/default-http-backend/proxy
Heapster is running at https://35.185.180.68/api/v1/namespaces/kube-system/services/heapster/proxy
KubeDNS is running at https://35.185.180.68/api/v1/namespaces/kube-system/services/kube-dns/proxy
kubernetes-dashboard is running at https://35.185.180.68/api/v1/namespaces/kube-system/services/kubernetes-dashboard/proxy
```

11. You can now start deploying apps to your GKE Cluster.

To deploy basic apps you can follow the [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/) tutorial.

If you want to try out [Istio](https://istio.io/) you can follow my Istio quick demo guide here https://kubernetes.io/docs/tutorials/kubernetes-basics/


12. Clean Up.

`cd terraform/`

To Destroy Terraform-managed infrastructure Run: `terraform destroy --force`

To Verify if all resources were deleted Runn: `terraform state list`. There shouldnt be any resources left, you can run `terraform destroy --force` again to force delete remaining resources.

`cd ..`

To Delete service account and credential Run: `make delete-service-account`

To Delete Terraform Run: `make delete-tf`

To Delete Project Run: `make delete-project`

