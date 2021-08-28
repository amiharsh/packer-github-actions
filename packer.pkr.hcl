packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
variable "aws_access_key_id" {
  type    = string
  default = "${env("AWS_ACCESS_KEY_ID")}"
}

variable "aws_secret_access_key" {
  type    = string
  default = "${env("AWS_SECRET_ACCESS_KEY")}"
}

variable "aws_session_token" {
  type    = string
  default = "${env("AWS_SESSION_TOKEN")}"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_id" {
  type = string
  default = "vpc-9cd616e1"
}
variable "subnet_id" {
  type = string
  default = "subnet-0be8ac46"
}
variable "source_ami" {
  type    = string
  default = "ami-09e67e426f25ce0d7"
}

variable "security_group" {
  type = string
  default = "sg-02d5d071ab4362e42"
}
source "amazon-ebs" "k3s-ami" {
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
  token = "${var.aws_session_token}"
  ami_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_size           = 20
    volume_type           = "gp2"
  }
  ami_description = "Ubuntu Image With Docker, K3S & Helm"
  ami_name        = "k3s-ami-helm"
  instance_type   = "t2.medium"
  profile         = "default"
  region          = "${var.region}"
  run_tags = {
    Name = "packer-builder"
  }
  security_group_id = "${var.security_group}"
  source_ami = "${var.source_ami}"
  ssh_timeout  = "5m"
  ssh_username = "ubuntu"
  subnet_id    = "${var.subnet_id}"
  tags = {
    Tool = "Packer"
  }
  vpc_id = "${var.vpc_id}"
}


build {
  sources = ["source.amazon-ebs.k3s-ami"]

  provisioner "file" {
    source =  "./user-data.sh"
    destination = "/tmp/user-data.sh"
    }
  provisioner "file" {
    source = "./rfnchart"
    destination = "/tmp/"
    }
  provisioner "shell" {
    execute_command = "sudo -E -S sh '{{ .Path }}'"
    script          = "./setup.sh"
  }

}
