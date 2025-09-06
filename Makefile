REPO_URL ?= https://github.com/isaacyera/hostaway-challenge
ARGOCD_NAMESPACE ?= "argocd"

.PHONY: up destroy prerequisites

prerequisites:
    @echo ">>> Installing prerequisites using Homebrew"
    @which brew >/dev/null 2>&1 || (echo "Installing Homebrew..." && /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")
    brew install minikube
    brew install kubectl
    brew install terraform
    brew install helm
    brew install git

up: prerequisites
	@echo ">>> Starting Minikube (if not already running)"
	@minikube status >/dev/null 2>&1 || minikube start
	@echo ">>> Terraform init/apply"
	cd terraform/1-ArgoCD && terraform init && terraform apply -auto-approve -var="argocd_namespace=$(ARGOCD_NAMESPACE)"
	cd terraform/2-App && terraform init && terraform apply -auto-approve -var="repo_url=$(REPO_URL)"

destroy:
	cd terraform/2-App && terraform destroy -auto-approve
	cd terraform/1-ArgoCD && terraform destroy -auto-approve
	@minikube delete
