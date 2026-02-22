terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "test" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id != "" ? var.subnet_id : null
  vpc_security_group_ids = length(var.security_group_ids) > 0 ? var.security_group_ids : null

  tags = {
    Name    = "image-factory-terratest"
    Purpose = "terratest"
  }
}

output "instance_id" {
  value = aws_instance.test.id
}

output "private_ip" {
  value = aws_instance.test.private_ip
}
