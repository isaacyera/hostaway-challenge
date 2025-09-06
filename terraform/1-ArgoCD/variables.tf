variable "argocd_namespace" {
  type        = string
  description = "Namespace where Argo CD will be installed."
  default     = "argocd"
}
