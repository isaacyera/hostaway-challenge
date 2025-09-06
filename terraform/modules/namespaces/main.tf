# Create one namespace per environment
resource "kubernetes_namespace" "ns" {
  for_each = local.namespaces

  metadata {
    name = each.value
    labels = {
      "app"        = var.application_name
      "env"        = each.key
      "visibility" = var.visibility
    }
  }
}

