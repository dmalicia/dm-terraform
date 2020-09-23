#### DRAFT UNDER TEST
terraform {
  backend "gcs" {
    bucket    = "dmustf"
    prefix    = "/dmus/frontend-aws-asg-tf"
    credentials = "/creds.json"
  }
}

resource "aws_instance" "cassandra_test_aws" {
  ami           = "ami-0f72889960844fb97"
  instance_type = "t3.micro"

  tags = {
    Name = ""
  }
}

module "asg" {
  count = var.asg_per_region[terraform.workspace]
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "frontend-aws-autoscale"

  # Launch configuration
  lc_name = "dm-lc"

  image_id        = "ami-0f72889960844fb97"
  instance_type   = "t2.micro"
  security_groups = ["sg-12345678"]

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "dm-asg"
  vpc_zone_identifier       = ["subnet-1235678", "subnet-87654321"]
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "prod"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "megasecret"
      propagate_at_launch = true
    },
  ]

  tags_as_map = {
    extra_tag1 = "dm extra_value1"
    extra_tag2 = "dm extra_value2"
  }
}
