resource "kubernetes_manifest" "project" {
  manifest = yamldecode(templatefile("${path.module}/manifests/appproject.yaml", {
    namespace = var.argocd_namespace
    name      = var.project_name
  }))
}

resource "kubernetes_manifest" "nginx_staging" {
  manifest = yamldecode(templatefile("${path.module}/manifests/application.yaml", {
    name             = var.app_name_staging
    namespace        = var.argocd_namespace
    project          = var.project_name
    repo_url         = var.repo_url
    target_revision  = var.target_revision_staging
    chart_path       = var.chart_path
    helm_values_file = "values-staging.yaml"
    dest_namespace   = var.dest_staging
    automated        = true
  }))
  depends_on = [kubernetes_manifest.project]
}

resource "kubernetes_manifest" "nginx_prod" {
  manifest = yamldecode(templatefile("${path.module}/manifests/application.yaml", {
    name             = var.app_name_prod
    namespace        = var.argocd_namespace
    project          = var.project_name
    repo_url         = var.repo_url
    target_revision  = var.target_revision_prod
    chart_path       = var.chart_path
    helm_values_file = "values-prod.yaml"
    dest_namespace   = var.dest_prod
    automated        = false
  }))
  depends_on = [kubernetes_manifest.project]
}
