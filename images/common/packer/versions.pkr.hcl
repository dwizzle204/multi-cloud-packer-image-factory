packer {
  required_version = "= 1.15.0"

  required_plugins {
    amazon = {
      version = "= 1.3.0"
      source  = "github.com/hashicorp/amazon"
    }
    azure = {
      version = "= 2.1.0"
      source  = "github.com/hashicorp/azure"
    }
    googlecompute = {
      version = "= 1.1.0"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}
