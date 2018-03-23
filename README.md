## terraform-gke

This is a quick guide to provision [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/) using [Terraform](https://www.terraform.io/docs/providers/google/index.html)

### Before you begin.

1. You'll need a [Google Cloud Platform](https://cloud.google.com/) account. 
2. Familiar with with [Kubernetes](https://kubernetes.io/), here's a good [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/) tutorial.
3. Familiar with [Terraform](https://www.terraform.io/), here's a good [Introduction to Terraform](https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180) tutorial.
4. [gcloud SDK](https://cloud.google.com/sdk/) configured or you can use [Google Cloud Shell](https://cloud.google.com/shell/).

## Usage

**1. Clone this repo.**

```
git clone https://github.com/ctaguinod/terraform-gke
cd terraform-gke
```

**2. Modify the variables in the file `Makefile`.**

Default variables: 

```
REGION=asia-southeast1
ZONE=asia-southeast1-a
GCP_BILLING_ACCOUNT=0X0X0X-0X0X0X-0X0X0X
GKE_CLUSTER_NAME=demo
TF_ADMIN_USER=terraform-admin
TF_CREDENTIAL=~/.gcp/$(TF_ADMIN_USER).json
TF_PROJECT_ID=$(USER)-terraform
TF_INSTALLER=https://releases.hashicorp.com/terraform/0.11.5/terraform_0.11.5_linux_amd64.zip
```

**3. Create New Project** - *you can skip this step if you already have a project and associated to billing.*

```
make create-project
```

This step creates a project named `${TF_PROJECT_ID}` and associates to billing account `GCP_BILLING_ACCOUNT`


**4. Create a Service Account** 

```
make create-tf-service-account
```

This step creates a service account $(TF_ADMIN_USER) and adds a project iam policy binding with roles/owner and creates a service account key in $(TF_CREDENTIAL)

**5. Install Terraform** - *you can skip this step if you already have terraform installed.*

```
make install-tf 
```

This step downloads the terraform binary in bin/ and /usr/local/bin/

**6. Modify the variables in the file `terraform/terraform.tfvars`**

Default variables:

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

**7. Run Terraform Commands inside `terraform/` directory**

`cd terraform/`

`terraform init` - This will initialize terraform.

`terraform plan` - This will generate execution plan.

`terraform apply` - This will build the terraform resources.

`cd ..`

**8. Configure kubectl credential** 

```
make kubectl-get-creds
```

**9. Verify if the cluster works**

```
kubectl cluster-info
```

If the cluster is working, `kubectl` can connect to the cluster and should show a result similar to the ff:

```
Kubernetes master is running at https://35.185.180.68
GLBCDefaultBackend is running at https://35.185.180.68/api/v1/namespaces/kube-system/services/default-http-backend/proxy
Heapster is running at https://35.185.180.68/api/v1/namespaces/kube-system/services/heapster/proxy
KubeDNS is running at https://35.185.180.68/api/v1/namespaces/kube-system/services/kube-dns/proxy
kubernetes-dashboard is running at https://35.185.180.68/api/v1/namespaces/kube-system/services/kubernetes-dashboard/proxy
```

**10. You can now start deploying apps to your GKE Cluster.**

To deploy basic apps you can follow the [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/) tutorial.

If you want to try out [Istio](https://istio.io/) you can follow my Istio quick demo guide here https://github.com/ctaguinod/istio-demo


**11. Cleaning Up.**

`cd terraform/`

`terraform state list` - This will list all terraform managed resources. 

`terraform destroy ` - **This will destroy all Terraform-managed resource, be carefull when running this command.** If you encounter some errors try to verify if there are still resources left by re running `terraform state list` and run `terraform destroy` again.

`cd ..`

`make delete-service-account` - This will delete the service account and the service account credential.

`make delete-tf` - This will delete terraform.

`make delete-project` - This will delete the project.

