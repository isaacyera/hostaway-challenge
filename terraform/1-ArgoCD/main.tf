module "argocd" {
  source           = "../modules/argocd"
  argocd_namespace = var.argocd_namespace
}