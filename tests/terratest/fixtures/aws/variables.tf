variable "region" {
  type = string
}

variable "image_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" {
  type    = string
  default = ""
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}
