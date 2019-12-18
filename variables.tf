variable "client_id" {
  type        = string
  description = "The Client ID which should be used. This can also be sourced from the ARM_CLIENT_ID Environment Variable."
}

variable "client_secret" {
  type        = string
  description = "The Client Secret which should be used. This can also be sourced from the ARM_CLIENT_SECRET Environment Variable."
}

variable "node_count" {
  type        = number
  default     = 3
  description = "The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100 and between min_count and max_count."
}

variable "ssh_public_key" {
  type        = string
  default     = "./ssh_key.pub"
  description = "An ssh_key block. Only one is currently allowed. Changing this forces a new resource to be created."
}

variable "admin_username" {
  type        = string
  default     = "ubuntu"
  description = "The Admin Username for the Cluster. Changing this forces a new resource to be created."
}

variable "dns_prefix" {
  type        = string
  default     = "test-aks"
  description = "DNS prefix specified when creating the managed cluster. Changing this forces a new resource to be created."
}

variable "cluster_name" {
  type        = string
  default     = "test-aks"
  description = "The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
}

variable "kubernetes_version" {
  type        = string
  default     = "1.14.8"
  description = "Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade)."
}

variable "resource_group_name" {
  type        = string
  default     = "aks-test"
  description = "Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created."
}
