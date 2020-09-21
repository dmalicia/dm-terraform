terraform {
  backend "gcs" { 
    bucket    = "dmustf"
    prefix    = "/dmus/frontend-gcp-asg-tf"
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

resource "google_compute_address" "asg" {
  count = var.asg_per_region[terraform.workspace]
  region = var.regions[terraform.workspace][count.index]
  name = "dmlc-autoscale-${random_id.instance_id.hex}"
}

# Create a Google Compute Forwarding Rule
resource "google_compute_forwarding_rule" "asg" {
  count      = var.asg_per_region[terraform.workspace]
  name       = "asg-forwarding-rule-${var.regions[terraform.workspace][count.index]}"
  region        = var.regions[terraform.workspace][count.index]
  target     = google_compute_target_pool.asg[count.index].self_link
  port_range = "80"
  ip_address = google_compute_address.asg[count.index].address
}

resource "google_compute_target_pool" "asg" {
  count      = var.asg_per_region[terraform.workspace]
  region        = var.regions[terraform.workspace][count.index]
  name          = "asg-target-pool-${var.regions[terraform.workspace][count.index]}"
  health_checks = ["${google_compute_http_health_check.asg[count.index].name}"]
}

# Create a Google Compute Http Health Check
resource "google_compute_http_health_check" "asg" {
  count                = var.asg_per_region[terraform.workspace]
  name                 = "asg-health-check-${var.regions[terraform.workspace][count.index]}"
  request_path         = "/"
  check_interval_sec   = 30
  timeout_sec          = 3
  healthy_threshold    = 2
  unhealthy_threshold  = 2
  port                 = var.server_port
}

#---------------------------------------------------------------------

# Create a Google Compute instance Group Manager
resource "google_compute_instance_group_manager" "asg" {

  count = var.asg_per_region[terraform.workspace]
  base_instance_name = "frontend-asg-${terraform.workspace}-${var.regions[terraform.workspace][count.index]}${count.index}"
  name = "asg-group-manager-${terraform.workspace}-${var.regions[terraform.workspace][count.index]}"
  zone = var.zones[terraform.workspace][count.index]
  version { 
  instance_template  = google_compute_instance_template.asg.self_link
  }
  target_pools       = ["${google_compute_target_pool.asg[count.index].self_link}"]
}

resource "google_compute_autoscaler" "asg" {
  count  = var.asg_per_region[terraform.workspace]
  name   = "asg-${terraform.workspace}-${var.regions[terraform.workspace][count.index]}"
  zone   = var.zones[terraform.workspace][count.index]
  target = "https://www.googleapis.com/compute/v1/projects/heroic-muse-289316/zones/us-central1-c/instanceGroupManagers/asg-group-manager-${terraform.workspace}-${var.regions[terraform.workspace][count.index]}"


  autoscaling_policy {
    max_replicas    = 1
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

# Create a Google Compute instance Template
resource "google_compute_instance_template" "asg" {
  machine_type  = "f1-micro"

  disk {
    source_image = "debian-cloud/debian-9"
  }

  network_interface {
    network = "default"
  }

  metadata_startup_script = file("${var.scbootstrap}/puppet.sh")
  metadata = {
    ssh-keys = "dmalicia:${file("${var.scpath}/id_rsa.pub")}"
             }


}

#---------------------------------------------------------------------
/*
# Create a Google Compute Backend Service
resource "google_compute_backend_service" "asg" {
  name        = "asg-backend-service"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false
  backend {
    group = "${google_compute_instance_group_manager.asg.instance_group}"
  }
  health_checks = ["${google_compute_http_health_check.asg.self_link}"]
}
*/
#---------------------------------------------------------------------
