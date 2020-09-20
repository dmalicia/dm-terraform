terraform {
  backend "gcs" { 
    bucket    = "dmustf"
    prefix    = "/dmus/frontend-gcp-nodes-tf"
    credentials = "/creds.json"
  }
}

data "google_secret_manager_secret_version" "basic" {
  secret = "creds"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

variable "node_count" {
  default = "0"
 }

// Resource for ips
resource "google_compute_address" "static" {
  count = "${var.nodes[terraform.workspace]}"
  name = "dmlc-frontend-0${count.index}${random_id.instance_id.hex}"
}

// A single Compute Engine instance
resource "google_compute_instance" "frontend" {
 count = "${var.nodes[terraform.workspace]}"
 name         = "dmlc-frontend-${count.index}${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

metadata_startup_script = file("${var.scbootstrap}/puppet.sh")
 metadata = {
   ssh-keys = "dmalicia:${file("${var.scpath}/id_rsa.pub")}"
            }

 network_interface {
   network = "default"

   access_config {
     nat_ip = google_compute_address.static[count.index].address
   }
 }
}

resource "google_compute_firewall" "frontend" {
 name    = "frontend-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["80","8140"]
 }
}
