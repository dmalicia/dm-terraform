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
  type        = string
  description = "The name of the Google Storage Bucket to create"
}
variable "storage-class" {
  type        = string
  description = "The storage class of the Storage Bucket to create"
}
