terraform {
  backend "gcs" { 
    bucket    = "dmustf"
    prefix    = "/dmus/frontend-tf"
    credentials = "/tmp/creds.json"
  }
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// Resource for ips
resource "google_compute_address" "static" {
  name = "dm-frontend-${random_id.instance_id.hex}"
}

// A single Compute Engine instance
resource "google_compute_instance" "frontend" {
 name         = "dm-frontend-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

metadata_startup_script = file("/initdm.sh")
 metadata = {
   ssh-keys = "dmalicia:${file("/id_rsa.pub")}"
            }
 network_interface {
   network = "default"

   access_config {
     nat_ip = google_compute_address.static.address
   }
 }
}

output "controller" {
  value = google_compute_instance.frontend.network_interface.0.access_config.0.nat_ip
}

resource "google_compute_firewall" "frontend" {
 name    = "frontend-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["80","8140"]
 }
}
