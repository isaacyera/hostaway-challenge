output "namespaces" {
  description = "Map of env -> namespace name."
  value       = { for k, v in kubernetes_namespace.ns : k => v.metadata[0].name }
}

output "visibility" {
  description = "The applied visibility (private/public)."
  value       = var.visibility
}
