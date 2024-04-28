variable "location" {}
variable "resource_group_name" {}
variable "acr_id" {}

locals {
  name               = "aks-ad"
  location           = "westeurope"
  kubernetes_version = "1.28"
  vm_size            = "Standard_B2s"
  node_count         = 2
  admin_group_object_ids = [
    "3673497d-1186-4942-8046-10ecd8acc14d",
  ]
}

resource "azurerm_kubernetes_cluster" "this" {
  name                              = local.name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  dns_prefix                        = local.name
  kubernetes_version                = local.kubernetes_version
  role_based_access_control_enabled = true
  oidc_issuer_enabled               = true

  default_node_pool {
    name       = replace(local.name, "-", "")
    node_count = local.node_count
    vm_size    = local.vm_size
    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = local.admin_group_object_ids
  }

  network_profile {
    network_plugin    = "azure"
    service_cidr      = "10.43.0.0/16"
    dns_service_ip    = "10.43.0.10"
    load_balancer_sku = "standard"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                            = var.acr_id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.this.identity[0].principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_public_ip" "ip-ingress" {
  name                = "${local.name}-ip-ingress"
  location            = var.location
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_public_ip" "ip-svc" {
  name                = "${local.name}-ip-svc"
  location            = var.location
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

output "azurerm_kubernetes_cluster" {
  value     = azurerm_kubernetes_cluster.this
  sensitive = true
}

output "kubeconfig" {
  value     = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}

output "ips" {
  value = {
    ingress = azurerm_public_ip.ip-ingress.ip_address
    svc     = azurerm_public_ip.ip-svc.ip_address
  }
}
