variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "image_id" {
  type = string
}

variable "os_type" {
  type    = string
  default = "linux"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  type    = string
  default = "packer"
}

variable "linux_ssh_public_key" {
  type        = string
  default     = ""
  description = "Required for Linux VM tests"
}

variable "windows_admin_password" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Required for Windows VM tests"
}
