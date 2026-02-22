# RHEL9 multi-cloud image build (template)
# - AWS: amazon-ebs AMI
# - Azure: azure-arm managed image
# - GCP: googlecompute image + family

# Common includes
source "amazon-ebs" "rhel9_aws" {
  region        = var.aws_region
  source_ami    = var.aws_source_ami
  instance_type = var.aws_instance_type

  ssh_username  = "ec2-user"

  ami_name      = "${var.image_name}-${var.image_version}"
  tags          = local.tags
}

source "azure-arm" "rhel9_azure" {
  # Auth is expected via environment (OIDC in workflows)
  location            = var.azure_location
  managed_image_name  = "${var.image_name}-${var.image_version}"
  managed_image_resource_group_name = var.azure_resource_group

  vm_size             = var.azure_vm_size

  image_publisher     = var.azure_source_image_publisher
  image_offer         = var.azure_source_image_offer
  image_sku           = var.azure_source_image_sku
  os_type             = "Linux"

  azure_tags          = local.tags
  communicator        = "ssh"
  ssh_username        = "packer"
}

source "googlecompute" "rhel9_gcp" {
  project_id          = var.gcp_project_id
  zone                = var.gcp_zone
  source_image        = var.gcp_source_image
  image_name          = "${var.image_name}-${replace(var.image_version, ".", "-")}"
  image_family        = var.gcp_image_family
  labels              = local.tags
  ssh_username        = "packer"
}

build {
  name    = "rhel9-multicloud"
  sources = [
    "source.amazon-ebs.rhel9_aws",
    "source.azure-arm.rhel9_azure",
    "source.googlecompute.rhel9_gcp",
  ]

  provisioner "shell" {
    script = "../common/scripts/linux/bootstrap-ansible.sh"
  }

  provisioner "ansible-local" {
    playbook_file   = "../common/ansible/playbooks/linux.yml"
    galaxy_file     = "../common/ansible/requirements.yml"
    # Pass metadata to Ansible
    extra_arguments = [
      "--extra-vars", "metadata.image_name=${var.image_name} metadata.image_version=${var.image_version} metadata.channel=${var.channel} metadata.git_sha=${var.git_sha} metadata.build_date=${var.build_date}"
    ]
  }

  provisioner "shell" {
    script = "../common/scripts/linux/finalize.sh"
  }
}
