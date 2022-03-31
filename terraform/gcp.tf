provider "google" {
    project = "omar-devops"
    credentials = "${file("credentials.json")}"
}

# Creating VPC

resource "google_compute_network" "vpc" {
    name = "main-vpc"
    auto_create_subnetworks = false
}

# Subnet 
resource "google_compute_subnetwork" "dev-subnet" {
name = "dev-subnet"
ip_cidr_range = "172.16.0.0/24"
region = "us-west1"
network = google_compute_network.vpc2.id
}

# Creating Main Cluster 

resource "google_container_cluster" "primary" {
  name     = "development-cluster"
  location = "us-west1-a"
  network = google_compute_network.vpc.id

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}


# Creating Main Node 

resource "google_container_node_pool" "primary_dev_nodes" {
  name       = "dev-pool"
  location   = "us-west1-a"
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

# Autopilot Cluster

resource "google_compute_network" "vpc2" {
    name = "prod-vpc"
    auto_create_subnetworks = false
}


# Subnet 
resource "google_compute_subnetwork" "prod-subnet" {
name = "prod-subnet"
ip_cidr_range = "172.16.0.0/24"
region = "us-west2"
network = google_compute_network.vpc2.id
}


resource "google_container_cluster" "autopilot" {
  name     = "production-cluster"
  location = "us-west2"
  network = google_compute_network.vpc2.id
  subnetwork = google_compute_subnetwork.prod-subnet.name
  enable_autopilot = true
}

