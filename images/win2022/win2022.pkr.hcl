# Windows 2022 multi-cloud image build (template)

source "amazon-ebs" "win2022_aws" {
  region        = var.aws_region
  source_ami    = var.aws_source_ami
  instance_type = var.aws_instance_type

  communicator  = "winrm"
  winrm_username = var.aws_winrm_username

  ami_name      = "${var.image_name}-${var.image_version}"
  tags          = local.tags
}

source "azure-arm" "win2022_azure" {
  location            = var.azure_location
  managed_image_name  = "${var.image_name}-${var.image_version}"
  managed_image_resource_group_name = var.azure_resource_group

  vm_size             = var.azure_vm_size

  image_publisher     = var.azure_source_image_publisher
  image_offer         = var.azure_source_image_offer
  image_sku           = var.azure_source_image_sku
  os_type             = "Windows"

  communicator        = "winrm"
  winrm_username      = "packer"
  winrm_insecure      = true
  winrm_use_ssl       = false

  azure_tags          = local.tags
}

source "googlecompute" "win2022_gcp" {
  project_id          = var.gcp_project_id
  zone                = var.gcp_zone
  source_image        = var.gcp_source_image
  image_name          = "${var.image_name}-${replace(var.image_version, ".", "-")}"
  image_family        = var.gcp_image_family
  labels              = local.tags

  communicator        = "winrm"
  winrm_username      = "packer"
  winrm_insecure      = true
  winrm_use_ssl       = false
}

build {
  name    = "win2022-multicloud"
  sources = [
    "source.amazon-ebs.win2022_aws",
    "source.azure-arm.win2022_azure",
    "source.googlecompute.win2022_gcp",
  ]

  # Bootstrap WinRM config suitable for runner-based Ansible
  provisioner "powershell" {
    script = "../common/scripts/windows/bootstrap-winrm.ps1"
  }

  # Runner-based Ansible execution over WinRM via Packer ansible provisioner.
  provisioner "ansible" {
    playbook_file   = "../common/ansible/playbooks/windows.yml"
    galaxy_file     = "../common/ansible/requirements.yml"
    extra_arguments = [
      "--extra-vars", "metadata.image_name=${var.image_name} metadata.image_version=${var.image_version} metadata.channel=${var.channel} metadata.git_sha=${var.git_sha} metadata.build_date=${var.build_date}"
    ]
  }

  provisioner "powershell" {
    script = "../common/scripts/windows/finalize.ps1"
  }
}
