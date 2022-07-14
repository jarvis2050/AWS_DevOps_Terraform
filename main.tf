terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "qyt_aws_vpc" {
  cidr_block = "10.8.0.0/16"

  tags = {
    Name = "qyt_aws_vpc"
  }
}

resource "aws_subnet" "qyt_outside_subnet" {
  vpc_id = aws_vpc.qyt_aws_vpc.id
  cidr_block = "10.8.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = format("%s%s", var.aws_region, "a")
  tags = {
    Name = "qyt_outside_subnet"
  }
}

resource "aws_internet_gateway" "qyt_internet_gw" {
  vpc_id = aws_vpc.qyt_aws_vpc.id

  tags = {
    Name = "qyt_internet_gw"
  }
}

resource "aws_route_table" "qyt_aws_route_table" {
  vpc_id = aws_vpc.qyt_aws_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.qyt_internet_gw.id
  }

  tags = {
    Name = "qyt_aws_route_table"
  }
}

resource "aws_route_table_association" "qyt_aws_route_table_association" {
  subnet_id      = aws_subnet.qyt_outside_subnet.id
  route_table_id = aws_route_table.qyt_aws_route_table.id
}


resource "aws_dynamodb_table" "dynamodb_table" {
  name = "staff"

  read_capacity  = var.db_read_capacity
  write_capacity = var.db_write_capacity
  hash_key       = "username"
  range_key      = "phone"

  attribute {
    name = "username"
    type = "S"
  }

  attribute {
    name = "phone"
    type = "S"
  }

  tags = {
    Name = "staff"
  }
}

resource "aws_security_group" "qyt_aws_allow_ssh_web" {
  name        = "ec_sg"
  description = "Allow ssh and web inbound traffic"
  vpc_id      = aws_vpc.qyt_aws_vpc.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "web"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec_sg"
  }
}

resource "aws_instance" "qytang_ec2" {
  key_name      = var.aws_region_key
  ami           = var.region_ami[var.aws_region]
  instance_type = "t2.micro"
  subnet_id = aws_subnet.qyt_outside_subnet.id
  iam_instance_profile = "WebService"
  security_groups = [aws_security_group.qyt_aws_allow_ssh_web.id]
  tags = {
    Name = "qytang ec2"
  }
  user_data = file("user_data.sh")
}

resource "aws_route53_record" "ec2web" {
  zone_id = "Z1JOS2YODO11W5"
  name    = "terraform.mingjiao.org"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.qytang_ec2.public_ip]
}
