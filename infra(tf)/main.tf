terraform {
  backend "s3" {
    bucket = "mridul-terraform-tfstate-bucket-19980"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "k3s_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.k3s_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.k3s_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.k3s_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "k3s_sg" {
  vpc_id = aws_vpc.k3s_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "k3s_master" {
  ami                    = "ami-01a00762f46d584a1" 
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]
  key_name               = "ansible-keypair"
  tags                   = { Name = "k3s-master" }
}

resource "aws_instance" "k3s_worker" {
  ami                    = "ami-01a00762f46d584a1"
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]
  key_name               = "ansible-keypair"
  tags                   = { Name = "k3s-worker" }
}