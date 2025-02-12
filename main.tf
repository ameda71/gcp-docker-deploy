provider "google" {
  credentials = file("cherr.json")
  project     = "<YOUR-PROJECT-ID>"
  region      = "us-central1"
}

resource "google_compute_instance" "web_server" {
  name         = "web-server"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10-buster-v20210916"
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
