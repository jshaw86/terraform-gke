// Service Account
resource "google_service_account" "gke_service_account" {
  account_id   = "${var.gke_service_account}"
  display_name = "GKE Service Account"
}

data "google_iam_policy" "gke_service_account_policy" {
  binding {
    role = "roles/storage.admin"

    members = [
      "serviceAccount:${google_service_account.gke_service_account.email}",
    ]
  }

  binding {
    role = "roles/logging.logWriter"

    members = [
      "serviceAccount:${google_service_account.gke_service_account.email}",
    ]
  }

  binding {
    role = "roles/monitoring.metricWriter"

    members = [
      "serviceAccount:${google_service_account.gke_service_account.email}",
    ]
  }

  binding {
    role = "roles/container.admin"

    members = [
      "serviceAccount:${google_service_account.gke_service_account.email}",
    ]
  }
}

resource "google_project_iam_policy" "gke_service_account_policy" {
  project     = "${var.project}"
  policy_data = "${data.google_iam_policy.gke_service_account_policy.policy_data}"
}
