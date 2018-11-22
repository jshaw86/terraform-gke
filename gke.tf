// GKE Cluster
data "google_compute_network" "gke_network" {
  project = "${var.project}"
  name    = "${google_compute_network.gke_network.name}"
}

resource "google_container_cluster" "gke_cluster" {
  project    = "${var.project}"
  name       = "${var.gke_cluster_name}"
  zone       = "${var.zone}"
  network    = "${data.google_compute_network.gke_network.id}"
  subnetwork = "cluster-net"

  //initial_node_count = "${var.initial_node_count}"
  node_version       = "${var.k8s_version}"
  min_master_version = "${var.k8s_version}"
  enable_legacy_abac = "false"

  additional_zones = [
    "${var.zone2}",
  ]

  ip_allocation_policy = {
    cluster_secondary_range_name  = "pod-net"
    services_secondary_range_name = "svc-net"
  }

  node_pool {
    name       = "default-pool"
    node_count = "${var.initial_node_count}"

    autoscaling {
      min_node_count = "${var.min_node_count}"
      max_node_count = "${var.max_node_count}"
    }

    node_config {
      preemptible     = false
      disk_size_gb    = "${var.disk_size_gb}"
      machine_type    = "${var.machine_type}"
      service_account = "${google_service_account.gke_service_account.email}"
    }
  }
}
