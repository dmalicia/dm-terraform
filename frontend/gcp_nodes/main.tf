terraform {
  backend "gcs" { 
    bucket    = "dmustf"
    prefix    = "/dmus/frontend-gcp-nodes-tf"
    credentials = "/creds.json"
  }
}

// just a test to store secret / I will store gh token
data "google_secret_manager_secret_version" "basic" {
  secret = "creds"
}

resource "random_id" "instance_id" {
 byte_length = 8
}

resource "google_compute_address" "static" {
  count = "${var.nodes[terraform.workspace]}"
  name = "dmlc-frontend-${count.index}${random_id.instance_id.hex}"
}

resource "google_compute_instance" "frontend" {
 count = "${var.nodes[terraform.workspace]}"
 name         = "dmlc-frontend-${terraform.workspace}-${count.index}"
 machine_type = "f1-micro"
 zone         = var.zones[terraform.workspace] 

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
