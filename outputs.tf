output "resource_group_id" {
  value       = azurerm_resource_group.k8s.id
  description = "The resource group ID."
}

output "fqdn" {
  value       = azurerm_kubernetes_cluster.k8s.fqdn
  description = "The FQDN of the Azure Kubernetes Managed Cluster."
}

output "client_key" {
  sensitive   = true
  value       = azurerm_kubernetes_cluster.k8s.kube_config.0.client_key
  description = "Base64 encoded private key used by clients to authenticate to the Kubernetes cluster."
}

output "client_certificate" {
  value       = azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate
  description = "Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster."
}

output "cluster_ca_certificate" {
  value       = azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate
  description = "Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster."
}

output "cluster_username" {
  value       = azurerm_kubernetes_cluster.k8s.kube_config.0.username
  description = "A username used to authenticate to the Kubernetes cluster."
}

output "cluster_password" {
  sensitive   = true
  value       = azurerm_kubernetes_cluster.k8s.kube_config.0.password
  description = "A password or token used to authenticate to the Kubernetes cluster."
}

output "host" {
  value       = azurerm_kubernetes_cluster.k8s.kube_config.0.host
  description = "The Kubernetes cluster server host."
}

output "kube_config" {
  sensitive   = true
  value       = azurerm_kubernetes_cluster.k8s.kube_config_raw
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools."
}

output "namespaces_metadata" {
  value       = kubernetes_namespace.this.*.metadata
  description = "Standard namespace's metadata."
}
