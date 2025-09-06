# Default deny all for private namespaces
resource "kubernetes_network_policy" "default_deny" {
  for_each = local.is_private ? kubernetes_namespace.ns : {}

  metadata {
    name      = "default-deny-all"
    namespace = each.value.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress", "Egress"]
  }
}

# Allow intra-namespace traffic
resource "kubernetes_network_policy" "allow_same_namespace" {
  for_each = local.is_private ? kubernetes_namespace.ns : {}

  metadata {
    name      = "allow-same-namespace"
    namespace = each.value.metadata[0].name
  }

  spec {
    pod_selector {}

    ingress {
      from {}
    }

    egress {
      to {}
    }

    policy_types = ["Ingress", "Egress"]
  }
}
