// Google Cloud provider
provider "google" {
  credentials = "${file("~/.gcp/terraform-admin.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}
