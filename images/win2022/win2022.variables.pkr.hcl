variable "aws_region" { type = string }
variable "aws_source_ami" { type = string }
variable "aws_instance_type" { type = string }
variable "aws_winrm_username" { type = string }

variable "azure_location" { type = string }
variable "azure_resource_group" { type = string }
variable "azure_vm_size" { type = string }
variable "azure_source_image_publisher" { type = string }
variable "azure_source_image_offer" { type = string }
variable "azure_source_image_sku" { type = string }

variable "gcp_project_id" { type = string }
variable "gcp_zone" { type = string }
variable "gcp_source_image" { type = string }
variable "gcp_image_family" { type = string }
