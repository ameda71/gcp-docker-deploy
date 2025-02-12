provider "google" {
  # Path to GCP service account key
  project     = var.project_id                             # GCP Project ID
  region      = var.region                                  # GCP region, e.g., "us-central1"
}

resource "google_compute_instance" "docker_instance" {
  name         = "docker-vm-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11-bullseye-v20210916"  # Debian image for VM
    }
  }

  network_interface {
    network = "default"
    access_config {
      // This provides the VM with an external IP address
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    docker --version
    docker pull ${var.docker_image}
    docker run -d -p 80:80 ${var.docker_image}  # Running the Docker container
  EOT
}

variable "project_id" {
  description = "The GCP Project ID"
  type        = string
  default = "siatejaameda"
}

variable "region" {
  description = "The GCP Region"
  type        = string
  default     = "us-central1"
}

variable "docker_image" {
  description = "Docker Image to Deploy"
  type        = string
  default = "sampled"
}
