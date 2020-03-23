terraform {
  # Версия terraform
  required_version = "~>0.12.8"
}

provider "google" {
  # Версия провайдера
  version = "~>2.15"

  # ID проекта
  project = var.project

  region = var.region
}

resource "google_compute_project_metadata_item" "default" {
  key     = "ssh-keys"
  value   = "${var.deploy_user}:${file(var.public_key_path)}"
  project = var.project
}

module "app" {
  source           = "../modules/app"
  zone             = var.zone
  machine_type     = var.machine_type
  deploy_user      = var.deploy_user
  private_key_path = var.private_key_path
  vm_count         = var.app_vm_count
  app_disk_image   = var.app_disk_image
  enable_provision = var.enable_provision
  env              = var.env
  image_to_run     = var.image_to_run

  vm_depends_on = [
    google_compute_project_metadata_item.default,
    module.vpc
  ]
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = var.ssh_source_ranges
  env           = var.env
}
