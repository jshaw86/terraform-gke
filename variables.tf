variable gke_cluster_name {
  description = "The name of the kubernetes cluster. Note that nodes names will be prefixed with `k8s-`"
}

variable project {
  description = "GCP Project"
}

variable cluster-net {
  description = "GKE Cluster Subnet"
  default     = "10.4.0.0/22"
}

variable pod-net {
  description = "GKE Pod Subnet"
  default     = "10.0.0.0/14"
}

variable svc-net {
  description = "GKE Service Subnet"
  default     = "10.4.4.0/22"
}

variable region {
  description = "Region"
}

variable zone {
  description = "Zone"
}

variable zone2 {
  description = "Additional Zone"
}

variable k8s_version {
  description = "Kubernetes Version"
  default     = "1.8.8-gke.0"
}

variable initial_node_count {
  description = "Initial Number of GKE Nodes"
  default     = "1"
}

variable min_node_count {
  description = "Autoscaling Min Number of GKE Nodes"
  default     = "1"
}

variable max_node_count {
  description = "Autoscaling Min Number of GKE Nodes"
  default     = "3"
}

variable disk_size_gb {
  description = "GKE Nodes Disk Size"
  default     = "100"
}

variable machine_type {
  description = "Machine Type"
  default     = "n1-standard-2"
}

variable gke_service_account {
  description = "GKE Service Account Name"
}
