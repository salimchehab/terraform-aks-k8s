# ----------------------------------------------------------------------------------------------------------------------
# Pinned to terraform version 0.12.10
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = "0.12.10"
}

provider "azurerm" {
  version = "~>1.5"
}

provider "kubernetes" {
  version = "~> 1.10"

  host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  version = "~> 0.10"
}
