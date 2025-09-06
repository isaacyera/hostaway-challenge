# ArgoCD Terraform Module

This module installs ArgoCD in your Kubernetes cluster using the official ArgoCD Helm chart.

## Resources

- **Helm Release:** Installs ArgoCD in the specified namespace.
- **CRD Wait:** Ensures ArgoCD CRDs (`AppProject`, `Application`) are established before proceeding.

## Inputs

| Name              | Type   | Description                              | Required |
|-------------------|--------|------------------------------------------|----------|
| argocd_namespace  | string | Namespace where ArgoCD will be installed | yes      |

## Files

- `helm-values/argocd-values.yaml`: Custom values for the ArgoCD Helm chart.

## Example Usage

```hcl
module "argocd" {
  source           = "./modules/argocd"
  argocd_namespace = "argocd"
}
```

## Notes

- The module will create the namespace if it does not exist.
- Make sure your Kubernetes provider is configured.
- The module waits for ArgoCD CRDs to be established before continuing.
- You can customize ArgoCD by editing `helm-values/argocd