locals {
  resource_group_name = "aks-training"
  location            = "westeurope"
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
}

module "acr" {
  source = "./acr"

  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
}

output "acr" {
  value     = module.acr
  sensitive = true
}

module "aks-basic" {
  source = "./basic"

  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  acr_id = module.acr.id
}

output "kubeconfig-basic" {
  value     = module.aks-basic.kubeconfig
  sensitive = true
}

module "aks-ad" {
  source = "./ad"

  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  acr_id = module.acr.id
}

output "kubeconfig-ad" {
  value     = module.aks-ad.kubeconfig
  sensitive = true
}

output "ips" {
  value = {
    basic-ingress = module.aks-basic.ips.ingress
    basic-svc     = module.aks-basic.ips.svc
    ad-ingress    = module.aks-ad.ips.ingress
    ad-svc        = module.aks-ad.ips.svc
  }
}
