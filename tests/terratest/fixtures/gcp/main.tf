terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  zone    = var.zone
}

resource "google_compute_instance" "test" {
  name         = "image-factory-terratest"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image_name
    }
  }

  network_interface {
    network = var.network
    access_config {}
  }

  labels = {
    purpose = "terratest"
  }
}

output "instance_name" {
  value = google_compute_instance.test.name
}

output "instance_id" {
  value = google_compute_instance.test.instance_id
}
