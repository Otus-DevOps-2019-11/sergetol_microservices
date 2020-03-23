variable "project" {
  description = "Project ID"
}

variable "region" {
  description = "Region"
  # Значение по умолчанию
  default = "europe-north1"
}

variable "zone" {
  description = "Zone"
  default     = "europe-north1-a"
}

variable "machine_type" {
  description = "Machine type"
  default     = "g1-small"
}

variable "deploy_user" {
  description = "User name user for ssh access"
}

variable "public_key_path" {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}

variable "app_vm_count" {
  description = "App VM count"
  default     = 1
}

variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "docker-base"
}

variable "enable_provision" {
  default = true
}

variable "ssh_source_ranges" {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}

variable "env" {
  description = "Environment name: e.g., stage, prod"
  default     = ""
}

variable "image_to_run" {
  description = "Docker image to run"
  default     = ""
}
