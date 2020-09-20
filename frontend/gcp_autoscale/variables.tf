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
variable "bucket-name" {
  default     = "dmustf"
}
variable "storage-class" {
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

variable "zones" {
  type      = map
  default = {
    amer = "us-east1-b"
    euro = "europe-west4-a"
    asia = "australia-southeast1-b"
}
}

variable "regions" {
  type      = map
  default = {
    amer = "us-east1"
    euro = "europe-west4"
    asia = "australia-southeast1"
}
}

variable "nodes" {
  type      = map
  default = {
    amer = "1"
    euro = "1"
    asia = "1"
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = "80"
}
