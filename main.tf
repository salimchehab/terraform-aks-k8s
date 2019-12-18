# ----------------------------------------------------------------------------------------------------------------------
# Create the resource group for aks
# ----------------------------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "k8s" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Test"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Create the aks cluster
# ----------------------------------------------------------------------------------------------------------------------
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  role_based_access_control {
    # produces dashboard access issues if set to true
    enabled = false
  }

  addon_profile {
    http_application_routing {
      enabled = false
    }
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  default_node_pool {
    name       = "primary"
    node_count = var.node_count
    vm_size    = "Standard_DS1_v2"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = "Test"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Local variables
# ----------------------------------------------------------------------------------------------------------------------
locals {
  namespaces = [
    "backend",
    "cert-manager",
    "frontend",
    "testing",
  ]
  labels = {
    environment         = "test"
    cluster_name        = var.cluster_name
    kubernetes_version  = var.kubernetes_version
    resource_group_name = var.resource_group_name
    location            = var.location
    fqdn                = azurerm_kubernetes_cluster.k8s.fqdn
  }
  helm_rpos = [
    {
      # Add appscode helm repo for kubedb helm chart
      name = "appscode",
      url  = "https://charts.appscode.com/stable/",
    },
    {
      # Add elastic helm repo for elasticsearch helm chart
      name = "elastic",
      url  = "https://helm.elastic.co",
    },
    {
      # Add jetstack helm repo for cert-manager helm chart
      name = "jetstack",
      url  = "https://charts.jetstack.io",
    },
    {
      # Add stable helm repo
      name = "stable",
      url  = "https://kubernetes-charts.storage.googleapis.com",
    },
  ]
  helm_releases = [
    {
      name       = "my-cert-manager"
      repository = "jetstack",
      chart      = "cert-manager",
      version    = "v0.12.0",
      namespace  = "cert-manager",
    },
    # {
    #   name       = "my-kubedb-operator",
    #   repository = "appscode",
    #   chart      = "kubedb",
    #   version    = "v0.13.0-rc.0",
    #   namespace  = "kube-system",
    # },
    {
      name       = "my-test-ingress",
      repository = "stable",
      chart      = "nginx-ingress",
      namespace  = "ingress",
    },
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Create the namespaces
# ----------------------------------------------------------------------------------------------------------------------
resource "kubernetes_namespace" "this" {
  count = length(local.namespaces)

  metadata {
    labels = local.labels
    name   = local.namespaces[count.index]
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Create the helm repos as a terraform data source
# ----------------------------------------------------------------------------------------------------------------------
data "helm_repository" "this" {
  count = length(local.helm_rpos)

  name = local.helm_rpos[count.index]["name"]
  url  = local.helm_rpos[count.index]["url"]
}

# ----------------------------------------------------------------------------------------------------------------------
# Create the helm charts
# ----------------------------------------------------------------------------------------------------------------------
resource "helm_release" "this" {
  count = length(local.helm_releases)

  name       = local.helm_releases[count.index]["name"]
  repository = local.helm_releases[count.index]["repository"]
  chart      = local.helm_releases[count.index]["chart"]
  version    = lookup(local.helm_releases[count.index], "version", null)
  namespace  = lookup(local.helm_releases[count.index], "namespace", "default")
  values     = lookup(local.helm_releases[count.index], "values", null)
}
