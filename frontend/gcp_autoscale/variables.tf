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
    amer = [ "us-west4-b", "us-east4-b" ] 
    euro = [ "europe-west6-a", "europe-north1-a" ]
    ocea = [ "australia-southeast1-b" ]
    asia = [ "asia-east2-b", "asia-south1-b" ] 
}
}

variable "regions" {
  type      = map
  default = {
    amer = [ "us-west4", "us-east4" ]
    euro = [ "europe-west6", "europe-north1" ]
    ocea = [ "australia-southeast1" ] 
    asia = [ "asia-east2" , "asia-south1" ]
}
}

variable "asg_per_region" {
  type      = map
  default = { 
    amer = "2"
    euro = "2"
    asia = "1"
    ocea = "1"
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = "80"
}
