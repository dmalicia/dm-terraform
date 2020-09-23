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
  default    = "/usr/local/share/dm-terraform/cassandra/bootstrap/"
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
    amer = [ "us-east1-b", "us-central-1c", "us-east1-a" ]
    euro = [ "europe-west4-a", "europe-north1-a", "europe-west4-a" ] 
}
}

variable "regions" {
  type      = map
  default = {
    amer = [ "us-east1", "us-central1", "us-east1" ]
    euro = [ "europe-west4", "europe-north1-a", "europe-west4" ] 
}
}

variable "nodes" {
  type      = map
  default = {
    amer = "1"
    euro = "1"
    asia = "0"
  }
}
