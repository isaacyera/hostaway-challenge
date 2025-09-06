#module "namespaces" {
#  source = "../modules/namespaces"
#
#  ext_staging      = "ext-staging"
#  ext_prod         = "ext-prod"
#  int_staging      = "int-staging"
#  int_prod         = "int-prod"
#}

module "namespaces" {
  source = "../modules/namespaces"

  application_name = var.application_name
  environments     = ["staging", "prod"]
  visibility       = "public"

}

module "app" {
  source = "../modules/app"

  argocd_namespace = var.argocd_namespace
  dest_staging     = "${var.application_name}-ext-staging"
  dest_prod        = "${var.application_name}-ext-prod"
  repo_url         = var.repo_url

  project_name     = "apps"
  app_name_staging = "nginx-staging"
  app_name_prod    = "nginx-prod"

  target_revision_staging = "staging"
  target_revision_prod    = "main"

  chart_path = "charts/nginx-hello"

  depends_on = [module.namespaces]
}
