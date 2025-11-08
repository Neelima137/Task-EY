terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
provider "google" {
  project     = var.project_id
  region      = var.region
}



resource "google_container_cluster" "cluster" {
  name     = var.cluster_name
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = "default"
  subnetwork = "default"
}

resource "google_container_node_pool" "nodes" {
  name       = "primary-node-pool"
  location   = var.region
  cluster    = google_container_cluster.cluster.name
  depends_on = [ google_container_cluster.cluster ]
  node_count = 2

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  autoscaling {
    min_node_count = 2
    max_node_count = 5
  }
}
