variable "zone" {
  description = "Zone"
  default     = "europe-north1-a"
}

variable "machine_type" {
  description = "Machine type"
  default     = "g1-small"
}

variable "deploy_user" {
  description = "User name used for ssh access"
}

variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}

variable "vm_count" {
  description = "VM count"
  default     = 1
}

variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "docker-base"
}

variable "vm_depends_on" {
  type    = any
  default = null
}

variable "enable_provision" {
  default = true
}

variable "env" {
  description = "Environment name: e.g., stage, prod"
  default     = ""
}

variable "image_to_run" {
  description = "Docker image to run"
  default     = ""
}
