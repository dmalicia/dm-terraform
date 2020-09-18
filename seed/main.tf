terraform {
  backend "gcs" { 
    bucket    = "dmustf"
    prefix    = "/dmus/seed-tf"
    credentials = "/tmp/creds.json"
  }
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// Resource for ips
resource "google_compute_address" "static" {
  name = "seed"
}

// A single Compute Engine instance
resource "google_compute_instance" "seed001" {
 name         = "dmus-seed-${random_id.instance_id.hex}"
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
  value = google_compute_instance.seed001.network_interface.0.access_config.0.nat_ip
}

resource "google_compute_firewall" "seed" {
 name    = "seed-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["5000","8500","8301","8300","8302","8140"]
 }
}
