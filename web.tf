

variable "access_key" {}

variable "secret_key" {}

terraform {
  required_version = ">= 0.11, < 0.12"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami = "ami-db24d8b6"
  instance_type = "t2.micro"


}


