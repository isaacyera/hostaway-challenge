resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = var.argocd_namespace
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"

  values = [file("${path.module}/helm-values/argocd-values.yaml")]
}

resource "null_resource" "wait_for_argocd_crds" {
  provisioner "local-exec" {
    command = <<EOT
set -e
kubectl wait --for=condition=Established --timeout=180s crd/appprojects.argoproj.io
kubectl wait --for=condition=Established --timeout=180s crd/applications.argoproj.io
EOT
  }
  depends_on = [helm_release.argocd]
}
