// Network
resource "google_compute_network" "gke_network" {
  name                    = "gke-custom-network"
  project                 = "${var.project}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "gke_subnet" {
  name          = "cluster-net"
  region        = "${var.region}"
  ip_cidr_range = "${var.cluster-net}"
  network       = "${google_compute_network.gke_network.self_link}"

  secondary_ip_range = [
    {
      range_name    = "pod-net"
      ip_cidr_range = "${var.pod-net}"
    },
    {
      range_name    = "svc-net"
      ip_cidr_range = "${var.svc-net}"
    },
  ]
}
