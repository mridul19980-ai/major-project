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
resource "aws_security_group" "main-server-sg" {
  name        = "main-server-sg"
  description = "Security group for main server"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}  
resource "aws_instance" "main_server" {
  ami           = "ami-07a00cf47dbbc844c"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.main-server-sg.id]
  subnet_id = "subnet-0ce9e8bded250e41b"
  associate_public_ip_address = true
  tags = {
    Name = "Main-server"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx

              EOF
}