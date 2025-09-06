variable "argocd_namespace" {
    type        = string
    description = "The Kubernetes namespace where ArgoCD is deployed."
}

variable "dest_staging" {
    type        = string
    description = "The destination cluster and namespace for the staging environment."
}

variable "dest_prod" {
    type        = string
    description = "The destination cluster and namespace for the production environment."
}

variable "repo_url" {
    type        = string
    description = "The Git repository URL containing the application manifests or Helm charts."
}

variable "project_name" {
    type        = string
    description = "The name of the ArgoCD project."
}

variable "app_name_staging" {
    type        = string
    description = "The name of the ArgoCD application for the staging environment."
}

variable "app_name_prod" {
    type        = string
    description = "The name of the ArgoCD application for the production environment."
}

variable "chart_path" {
    type        = string
    description = "The path to the Helm chart within the repository."
}

variable "target_revision_staging" {
    type        = string
    description = "The Git revision (branch, tag, or commit) to deploy for staging."
}

variable "target_revision_prod" {
    type        = string
    description = "The Git revision (branch, tag, or commit) to deploy for production."
}
