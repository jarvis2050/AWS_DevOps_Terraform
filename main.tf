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
#  region = "us-east-1"
  region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "test_aws_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "test_only_vpc"
  }
}

# Create a Subnet
resource "aws_subnet" "test_aws_subnet" {
  vpc_id     = aws_vpc.test_aws_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "test_aws_subnet"
  }
}

resource "aws_subnet" "test_aws_subnet_2" {
  vpc_id     = aws_vpc.test_aws_vpc.id
  cidr_block = "10.0.2.0/24"
#  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "test_aws_subnet_2"
  }
}