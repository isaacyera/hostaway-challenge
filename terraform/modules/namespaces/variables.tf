variable "application_name" {
  type        = string
  description = "Application name prefix for namespaces (e.g., nginx, payments)."
}

variable "environments" {
  type        = list(string)
  description = "Environments to create (e.g., [\"staging\", \"prod\"])."
}

variable "visibility" {
  type        = string
  description = "Namespace visibility: \"private\" (int-<env>) or \"public\" (ext-<env>)."
  default     = "private"
  validation {
    condition     = contains(["private", "public"], var.visibility)
    error_message = "visibility must be one of: \"private\", \"public\"."
  }
}

variable "argocd_namespace" {
  type        = string
  description = "ArgoCD namespace (used only if enable_allow_from_argocd = true)."
  default     = "argocd"
}

variable "enable_allow_from_argocd" {
  type        = bool
  description = "If true, allow ingress from the ArgoCD namespace into private namespaces."
  default     = false
}
