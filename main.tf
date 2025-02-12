provider "google" {
  project     = "project-irshaq"
  region      = "us-central1"
}

resource "google_compute_instance" "web_server" {
  name         = "web-server"
  machine_type = "e2-micro"
  zone         = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
    echo "<h1>Welcome to the Web Server</h1>" > /var/www/html/index.html
  EOT
}

output "instance_ip" {
  value = google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip
}
