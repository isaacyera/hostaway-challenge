# Hostaway Challenge

This repository demonstrates a local GitOps workflow using **Minikube**, **Terraform**, **Helm**, and **ArgoCD** for deploying a Helm-based Nginx application to Kubernetes. It is structured for modularity, automation, and clarity, making it suitable for local development, testing, and as a template for production environments.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Start the Environment](#start-the-environment)
  - [Destroy the Environment](#destroy-the-environment)
- [GitOps Workflow](#gitops-workflow)
- [Monitoring Metrics & Thresholds](#monitoring-metrics--thresholds)
- [Terraform Modules](#terraform-modules)
- [Helm Chart](#helm-chart)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [References](#references)

---

## Overview

This repository provisions:

- **Minikube**: Local Kubernetes cluster.
- **ArgoCD**: GitOps tool for Kubernetes, installed via Helm.
- **Namespaces**: Segregated environments (internal/external × staging/production).
- **Nginx Application**: Deployed via Helm and managed by ArgoCD.
- **Terraform**: Infrastructure as Code for all resources.

---

## Architecture

```
+-------------------+
|      Minikube     |
+-------------------+
        |
+-------------------+
|     ArgoCD        |  <-- Installed in its own namespace
+-------------------+
        |
+-------------------+
|   Namespaces      |  <-- Internal/External, Staging/Production
+-------------------+
        |
+-------------------+
| Nginx Application |  <-- Deployed via Helm, managed by ArgoCD
+-------------------+
```

- **ArgoCD** watches the Git repository and syncs application manifests.
- **Terraform** provisions all resources, including ArgoCD, namespaces, and application manifests.

---

## Project Structure

```
hostaway-challenge/
│
├── Makefile                # Automation for setup/teardown
├── README.md               # Project documentation
│
├── charts/
│   └── nginx-hello/        # Helm chart for Nginx app
│
├── terraform/
│   ├── 1-ArgoCD/           # Deploys ArgoCD via Helm
│   ├── 2-App/              # Deploys Nginx app via ArgoCD
│   └── modules/
│       ├── app/            # Terraform module for ArgoCD Application & Project
│       ├── argocd/         # Terraform module for ArgoCD installation
│       └── namespaces/     # Terraform module for Kubernetes namespaces
```

---

## Prerequisites

- Linux/macOS (Windows WSL2 supported)
- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [Homebrew](https://brew.sh/) (for macOS package management)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Terraform](https://www.terraform.io/downloads.html) >= 1.6
- [Helm](https://helm.sh/docs/intro/install/) 3
- Docker
- GNU Make (for using the Makefile)
- Git
- Optional: [argocd CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/)

---

## Usage

### Start the Environment

This will start Minikube, install ArgoCD, create namespaces, and deploy the Nginx app.

```sh
make up REPO_URL=https://github.com/<your-username>/hostaway-devops-task
```

- **Minikube** will start if not already running.
- **Terraform** will initialize and apply configurations for ArgoCD and the application.

### Destroy the Environment

This will remove all resources and stop Minikube.

```sh
make destroy
```

Or manually:

```sh
cd terraform/2-App && terraform destroy -auto-approve
cd terraform/1-ArgoCD && terraform destroy -auto-approve
minikube delete
```

---

## GitOps Workflow

- Branch `staging`: auto-syncs `nginx-staging`
- Branch `main`: manual sync for `nginx-prod`
- Deploy to **staging**, promote to **production**, rollback to any previous version

---

## Monitoring Metrics & Thresholds

### Key Monitoring Metrics & Thresholds

- **HTTP 5xx error rate >0.5% (production) / >2% (staging)**  
        Even small increases in backend errors can indicate outages, misconfigurations, or code issues.
- **Latency p95 >200ms (production) / >400ms (staging)**  
        High latency impacts user experience and may signal performance bottlenecks or resource constraints.
- **Pod restarts >=2 in 10m**  
        Frequent restarts often point to application instability, crashes, or resource limits.
- **CPU >75% or Memory >80% for 10m**  
        Sustained high resource usage can degrade performance or cause pod evictions.
- **ArgoCD app not Healthy/Synced >3m**  
        Ensures deployments are current; delays may block releases or indicate sync issues.
- **Immediate alert for CrashLoopBackOff or ImagePullBackOff events**  
        Detects failed pods or image problems that prevent application availability.

These alerts are important because they enable rapid detection of reliability, performance, and deployment issues, allowing quick intervention to minimize downtime and maintain service quality.

---

## Terraform Modules

### 1. ArgoCD Module (`modules/argocd`)

- Installs ArgoCD using the official Helm chart.
- Waits for CRDs to be established.
- Customizable via `helm-values/argocd-values.yaml`.

### 2. Namespaces Module (`modules/namespaces`)

- Creates namespaces for different environments.
- Applies labels for organization and selection.

### 3. App Module (`modules/app`)

- Provisions ArgoCD `AppProject` and `Application` resources.
- Deploys the Nginx Helm chart to staging and production namespaces.

---

## Helm Chart

- Located in `charts/nginx-hello/`.
- Contains templates for deployment, service, configmap, and values files for staging and production.
- Customizable for your own application.

---

## Customization

- **ArgoCD Values**: Edit `modules/argocd/helm-values/argocd-values.yaml` for custom ArgoCD settings. You may move this file to `terraform/1-ArgoCD/` and use it as an input variable.
- **Namespace Names**: Change variables in the modules or locals in `locals.tf`.
- **Application Settings**: Modify variables in `modules/app/variables.tf` and Helm values files in `charts/nginx-hello/`.

---

## Troubleshooting

- Ensure Minikube is running: `minikube status`
- Check Terraform output for errors.
- Use `kubectl get pods -A` to inspect resource status.
- ArgoCD UI can be accessed via port-forwarding:
  ```sh
  kubectl port-forward svc/argocd-server -n argocd 8080:80
  ```
  Then visit [https://localhost:8080](https://localhost:8080).

  Or using Minikube service command:
  ```sh
  minikube service -n argocd argocd-server
  ```
  To get the default admin password for ArgoCD excute
  ```sh
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
  ```

---

## References

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)