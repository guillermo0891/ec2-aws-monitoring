terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amzn2023" {
  most_recent = true
  owners      = ["137112412989"] # Amazon owner ID
  filter {
 name   = "name"
 values = ["amzn-2023-", "amzn-ami-2023-", "amzn-2023-hvm-*", "al2023-ami-2023.*"]
  }
  filter {
 name   = "architecture"
 values = ["x86_64"]
  }
}