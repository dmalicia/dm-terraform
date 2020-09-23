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
  access_key = "xxx"
  secret_key = "xxx"
}

resource "aws_instance" "web" {
  ami           = "ami-0f72889960844fb97"
  instance_type = "t3.micro"

  tags = {
    Name = "Init"
  }
}
