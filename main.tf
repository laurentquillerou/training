#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-fcc4db98
#
# Your subnet ID is:
#
#     subnet-4a354a07
#
# Your security group ID is:
#
#     sg-b7fd79df
#
# Your Identity is:
#
#     terraform-training-peafowl
#

terraform {
  backend "atlas" {
    name = "laurentquillerou/training"
  }
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "num_webs" {
  default = "1"
}

variable "aws_region" {
  type    = "string"
  default = "eu-west-2"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

variable "cmd" {
  default = "whoami"
}

resource "aws_instance" "web" {
  ami           = "ami-fcc4db98"
  instance_type = "t2.micro"
  count         = "${var.num_webs}"

  subnet_id              = "subnet-4a354a07"
  vpc_security_group_ids = ["sg-b7fd79df"]

  tags {
    Identity = "terraform-training-peafowl"
    Name     = "web ${count.index + 1}/${var.num_webs}"
    second   = "tags"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}
