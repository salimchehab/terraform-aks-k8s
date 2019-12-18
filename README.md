# Intro

This repo intends to be a starting point for building a kubernetes cluster using [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/).

The terraform scripts creates the following:

- AKS resource group
- AKS cluster
- Kubernetes namespaces (backend, fronted, and testing)
- Helm repos

# Getting started

- [Install the Azure CLI
](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- log in to azure: `az login`

# Terraform Versions and Plugins

The terraform plugins directory `~/.terraform.d/plugins` contains the following provider plugins:
- terraform-provider-helm_v0.10.4_x4
- terraform-provider-kubernetes_v1.10.0_x4
- terraform-provider-azurerm_v1.39.0_x4

Terraform version 0.12.10 was used for the setup:
```bash
$ terraform --version
Terraform v0.12.10
+ provider.azurerm v1.39.0
+ provider.helm v0.10.4
+ provider.kubernetes v1.10.0
```

# AKS

Based on [Tutorial: Create a Kubernetes cluster with Azure Kubernetes Service using Terraform](https://docs.microsoft.com/en-us/azure/terraform/terraform-create-k8s-cluster-with-tf-and-aks).

Run the terraform commands:
```bash
# export service principal credentials
export TF_VAR_client_id=<service-principal-appid>
export TF_VAR_client_secret=<service-principal-password>
# init
terraform init
# plan
terraform plan -out out.tfplan
# apply
terraform apply "out.tfplan"
```

Export kube config:
```bash
# store local kubeconfig
echo "$(terraform output kube_config)" > ./azurek8s
# export the correct config file
export KUBECONFIG=./azurek8s
```

In order to get the aks cluster credentials:
```bash
az aks get-credentials --resource-group aks-test --name test-aks
```

In order to add the aks cluster credentials to `~/.kube/config`:
```bash
$ az aks get-credentials --resource-group aks-test --name test-aks
```

Check the nodes and namespaces:
```bash
$ kubectl get nodes -o wide
NAME                              STATUS   ROLES   AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
aks-primary-32249617-vmss000000   Ready    agent   28m   v1.14.8   10.240.0.4    <none>        Ubuntu 16.04.6 LTS   4.15.0-1061-azure   docker://3.0.7
aks-primary-32249617-vmss000001   Ready    agent   28m   v1.14.8   10.240.0.5    <none>        Ubuntu 16.04.6 LTS   4.15.0-1061-azure   docker://3.0.7
aks-primary-32249617-vmss000002   Ready    agent   28m   v1.14.8   10.240.0.6    <none>        Ubuntu 16.04.6 LTS   4.15.0-1061-azure   docker://3.0.7
$ kubectl get ns
NAME              STATUS   AGE
backend           Active   21m
cert-manager      Active   21m
default           Active   32m
frontend          Active   21m
ingress           Active   21m
kube-node-lease   Active   32m
kube-public       Active   32m
kube-system       Active   32m
testing           Active   21m
```

View the dashboard:
```bash
az aks browse --resource-group aks-test --name test-aks
```

# Terraform Docs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin\_username | The Admin Username for the Cluster. Changing this forces a new resource to be created. | string | `"ubuntu"` | no |
| client\_id | The Client ID which should be used. This can also be sourced from the ARM_CLIENT_ID Environment Variable. | string | n/a | yes |
| client\_secret | The Client Secret which should be used. This can also be sourced from the ARM_CLIENT_SECRET Environment Variable. | string | n/a | yes |
| cluster\_name | The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created. | string | `"test-aks"` | no |
| dns\_prefix | DNS prefix specified when creating the managed cluster. Changing this forces a new resource to be created. | string | `"test-aks"` | no |
| kubernetes\_version | Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). | string | `"1.14.8"` | no |
| location | The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created. | string | `"westeurope"` | no |
| node\_count | The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100 and between min_count and max_count. | number | `"3"` | no |
| resource\_group\_name | Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created. | string | `"aks-test"` | no |
| ssh\_public\_key | An ssh_key block. Only one is currently allowed. Changing this forces a new resource to be created. | string | `"./ssh_key.pub"` | no |

## Outputs

| Name | Description |
|------|-------------|
| client\_certificate | Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster. |
| client\_key | Base64 encoded private key used by clients to authenticate to the Kubernetes cluster. |
| cluster\_ca\_certificate | Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster. |
| cluster\_password | A password or token used to authenticate to the Kubernetes cluster. |
| cluster\_username | A username used to authenticate to the Kubernetes cluster. |
| fqdn | The FQDN of the Azure Kubernetes Managed Cluster. |
| host | The Kubernetes cluster server host. |
| kube\_config | Raw Kubernetes config to be used by kubectl and other compatible tools. |
| namespaces\_metadata | Standard namespace's metadata. |
| resource\_group\_id | The resource group ID. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->