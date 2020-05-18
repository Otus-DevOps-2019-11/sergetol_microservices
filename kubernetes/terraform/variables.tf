variable "project" {
  type        = string
  description = "Project ID"
}

variable "region" {
  type        = string
  description = "Region"
  default     = "europe-north1"
}

variable "zone" {
  type        = string
  description = "Zone"
  default     = "europe-north1-a"
}

variable "cluster_name" {
  type        = string
  description = "K8s cluster name"
  default     = "cluster-1"
}

variable "node_pool_name" {
  type        = string
  description = "K8s cluster node pool name"
  default     = "node-pool-1"
}

variable "node_count" {
  type        = number
  description = "K8s cluster node count"
  default     = 1
}

variable "node_machine_type" {
  type        = string
  description = "K8s cluster node machine type"
  default     = "g1-small"
}

variable "node_disk_size_gb" {
  type        = number
  description = "K8s cluster node disk size, Gb"
  default     = 20
}

variable "node_disk_type" {
  type        = string
  description = "K8s cluster node disk type"
  default     = "pd-standard"
}

variable "node_tags" {
  type        = list(string)
  description = "K8s cluster node tags"
  default     = ["k8s-work-node"]
}

variable "firewall_node_ports" {
  type        = list(string)
  description = "Firewall k8s node ports"
  default     = ["30000-32767"]
}

variable "firewall_source_ranges" {
  type        = list(string)
  description = "Firewall source ranges"
  default     = ["0.0.0.0/0"]
}
