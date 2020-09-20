terraform {
  backend "gcs" {
    bucket    = "dmustf"
    prefix    = "/dmus/dns-tf"
    credentials = "/creds.json"
  }
}

resource "google_dns_managed_zone" "prod" {
  name     = var.name
  dns_name = var.domain
}
