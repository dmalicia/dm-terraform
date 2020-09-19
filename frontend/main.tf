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

variable "node_count" {
  default = "2"
 }

// Resource for ips
resource "google_compute_address" "static" {
  name = "dm-frontend-${random_id.instance_id.hex}"
}

// A single Compute Engine instance
resource "google_compute_instance" "frontendn" {
 count        = var.node_count
 name         = "dm-frontend-${count.index}${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

metadata_startup_script = file("/puppet.sh")
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

resource "google_compute_firewall" "frontendn" {
 name    = "frontend-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["80","8140"]
 }
}
