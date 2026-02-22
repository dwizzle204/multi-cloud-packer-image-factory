locals {
  tags = {
    image_name   = var.image_name
    image_version= var.image_version
    channel      = var.channel
    git_sha      = var.git_sha
    build_date   = var.build_date
  }
}
