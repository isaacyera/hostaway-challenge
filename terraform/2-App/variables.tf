variable "repo_url" {
  type        = string
  description = "Git repo URL Argo CD will track"
  default     = "https://github.com/isaacyera/hostaway-challenge"
}

variable "argocd_namespace" {
  type        = string
  description = "ArgoCD namespace"
  default     = "argocd"
}

variable "application_name" {
  type        = string
  description = "application name"
  default     = "nginx"
}