# define GCP region
variable "gcp_region" {
  type        = string
  description = "GCP region"
}
# define GCP project name
variable "gcp_project" {
  type        = string
  description = "GCP project name"
}
# GCP authentication file
variable "gcp_auth_file" {
  type        = string
  description = "GCP authentication file"
}
variable "bucket_name" {
  default     = "dmustf"
}
variable "storage_class" {
  type        = string
  description = "The storage class of the Storage Bucket to create"
}

# Source code folder
variable "scbootstrap" {
  type       = string
  default    = "/usr/local/share/dm-terraform/frontend/bootstrap/"
}

# Seed Creds
variable "scpath" {
  type       = string
  default    = "/usr/local/share/dm-terraform/seed/bootstrap/"
}

# define dns
variable "dns_name" {
  type        = string
  description = "The name of the DNS"
}
# define domain
variable "dns_domain" {
  type        = string
  description = "The domain of the DNS"
}

variable "zones" {
  type      = map
  default = {
    amer = [ "us-east1-b", "us-central-1c" ]
    euro = [ "europe-west4-a", "europe-north1-a" ] 
    asia = [ "australia-southeast1-b", "asia-northeast1-b" ] 
}
}

variable "regions" {
  type      = map
  default = {
    amer = [ "us-east1", "us-central1" ]
    euro = [ "europe-west4", "europe-north1-a" ] 
    asia = [ "australia-southeast1", "asia-northeast" ]
}
}

variable "nodes" {
  type      = map
  default = {
    amer = "1"
    euro = "0"
    asia = "0"
  }
}
