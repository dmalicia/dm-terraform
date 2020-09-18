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
 name         = "dmalicia-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

// Make sure flask is installed on all new instances for later steps
//   metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"
   metadata_startup_script = file("/tmp/controllerbootstrap.sh")
 metadata = {
   ssh-keys = "dmalicia:${file("/tmp/id_rsa.pub")}"
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
