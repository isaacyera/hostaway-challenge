# App Module

This Terraform module provisions ArgoCD `AppProject` and `Application` resources for deploying a Helm-based Nginx app to Kubernetes.

## Resources

- `kubernetes_manifest.project`: Creates an ArgoCD AppProject.
- `kubernetes_manifest.nginx_staging`: Registers the Nginx staging application.
- `kubernetes_manifest.nginx_prod`: Registers the Nginx production application.

## Inputs

| Name                   | Type   | Description                                 | Required |
|------------------------|--------|---------------------------------------------|----------|
| argocd_namespace       | string | Namespace where ArgoCD is installed         | yes      |
| dest_staging           | string | Destination namespace for staging           | yes      |
| dest_prod              | string | Destination namespace for production        | yes      |
| repo_url               | string | Git repository URL for Helm chart           | yes      |
| project_name           | string | ArgoCD AppProject name                      | yes      |
| app_name_staging       | string | Name for staging application                | yes      |
| app_name_prod          | string | Name for production application             | yes      |
| chart_path             | string | Path to Helm chart in repo                  | yes      |
| target_revision_staging| string | Git branch/revision for staging             | yes      |
| target_revision_prod   | string | Git branch/revision for production          | yes      |

## Example Usage

```hcl
module "app" {
  source                  = "./modules/app"
  argocd_namespace        = "argocd"
  dest_staging            = "ext-staging"
  dest_prod               = "ext-prod"
  repo_url                = "https://github.com/your/repo"
  project_name            = "apps"
  app_name_staging        = "nginx-staging"
  app_name_prod           = "nginx-prod"
  chart_path              = "charts/nginx-hello"
  target_revision_staging = "staging"
  target_revision_prod    = "prod"
}
```

## Notes

- This module expects ArgoCD and target namespaces to be provisioned.
- The Helm chart path and values files must exist in the specified