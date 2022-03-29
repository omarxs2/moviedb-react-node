provider "google" {
    project = "omar-devops"
    credentials = "${file("credentials.json")}"
}

# Creating VPC

resource "google_compute_network" "vpc" {
    name = "main-vpc"
    auto_create_subnetworks = true
}


# Creating Main Cluster 

resource "google_container_cluster" "primary" {
  name     = "development-cluster"
  location = "us-central1-a"
  network = google_compute_network.vpc.id

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}


# Creating Main Node 

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = "terraform-sa@omar-devops.iam.gserviceaccount.com"
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}


# Native Cluster Example

# resource "google_compute_network" "dev-vpc" {
#   name                    = "dev-vpc"
#   auto_create_subnetworks = false
# }

# resource "google_compute_subnetwork" "dev-subnet" {
#   name          = "dev-subnet"
#   ip_cidr_range = "10.2.0.0/16"
#   region        = "us-central1"
#   network       = google_compute_network.dev-vpc.id
#   secondary_ip_range {
#     range_name    = "services-range"
#     ip_cidr_range = "192.168.1.0/24"
#   }

#   secondary_ip_range {
#     range_name    = "pod-ranges"
#     ip_cidr_range = "192.168.64.0/22"
#   }
# }


# resource "google_container_cluster" "dev-cluster" {
#   name               = "dev-cluster"
#   location           = "us-central1"
#   initial_node_count = 1

#   network    = google_compute_network.dev-vpc.id
#   subnetwork = google_compute_subnetwork.dev-subnet.id

#   ip_allocation_policy {
#     cluster_secondary_range_name  = "services-range"
#     services_secondary_range_name = google_compute_subnetwork.dev-subnet.secondary_ip_range.1.range_name
#   }
# }