terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIATRGGCDTED7JPGCFI"
  secret_key = "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"
}
