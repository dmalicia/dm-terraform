# define dns
variable "name" {
  type        = string
  description = "The name of the DNS"
}
# define domain
variable "domain" {
  type        = string
  description = "The domain of the DNS"
}

# define gcp region
variable "gcp_region" {
  type        = string
  description = "GCP region"
}
# define gcp project name
variable "gcp_project" {
  type        = string
  description = "GCP project name"
}
# gcp authentication file
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


