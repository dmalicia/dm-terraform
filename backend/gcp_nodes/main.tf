terraform {
  backend "gcs" { 
    bucket    = "dmustf"
    prefix    = "/dmus/backend-gcp-nodes-tf"
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
  count = var.nodes[terraform.workspace]
  name = "dmlc-backend-${count.index}${random_id.instance_id.hex}"
  region = var.regions[terraform.workspace][count.index]
}

resource "google_compute_instance" "backend" {
 count = "${var.nodes[terraform.workspace]}"
 name         = "backend-${terraform.workspace}-${count.index}"
 machine_type = "f1-micro"
 zone         = var.zones[terraform.workspace][count.index] 

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

resource "google_dns_record_set" "backend" {
  count = "${var.nodes[terraform.workspace]}"
  name = "backend${count.index}.${terraform.workspace}.${var.dns_domain}"
  type = "A"
  ttl  = 300

  managed_zone = var.dns_name

  rrdatas = [google_compute_address.static[count.index].address]
}
