variable "access_key" {}

variable "secret_key" {}

terraform {
  required_version = ">= 0.11, < 0.12"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "ap-southeast-2"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "hashitop-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_security_group" "hashitop_allow_ssh" {
  name        = "hashitop_allow_ssh"
  description = "Allow TLS inbound traffic"
  vpc_id = "${aws_vpc.main.id}" 
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

}

resource "aws_instance" "web" {
  ami = "ami-0fb7513bcdc525c3b"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.main.id}"
  vpc_security_group_ids = [ "${aws_security_group.hashitop_allow_ssh.id}" ]
  key_name = "top-ec2-sydney"
  associate_public_ip_address = true
}
