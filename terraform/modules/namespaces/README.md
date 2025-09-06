# Namespace Module

This Terraform module creates Kubernetes namespaces for a given **application** across multiple **environments**, with configurable **visibility** (`private` or `public`).

* **Public namespaces** (`*-ext-*`) are created with no network restrictions.
* **Private namespaces** (`*-int-*`) are created with **NetworkPolicies** to restrict traffic:

  * `default-deny-all`: denies all ingress and egress by default
  * `allow-same-namespace`: allows pods in the same namespace to communicate with each other

---

## Inputs

| Name               | Type           | Default     | Description                                                                |
| ------------------ | -------------- | ----------- | -------------------------------------------------------------------------- |
| `application_name` | `string`       | n/a         | Name prefix for namespaces (e.g. `nginx`, `payments`).                     |
| `environments`     | `list(string)` | n/a         | List of environments to create namespaces for (e.g. `["staging","prod"]`). |
| `visibility`       | `string`       | `"private"` | Namespace visibility: `"private"` or `"public"`.                           |

---

## Outputs

| Name         | Description                                       |
| ------------ | ------------------------------------------------- |
| `namespaces` | Map of environment → namespace name.              |
| `visibility` | The applied visibility mode (`private`/`public`). |

---

## Behavior

* Namespace names are generated as:

  * **Private:** `<application_name>-int-<env>`
  * **Public:** `<application_name>-ext-<env>`

* If visibility = `"private"`, each namespace gets:

  * A **default-deny** NetworkPolicy (no ingress/egress allowed).
  * An **allow-same-namespace** NetworkPolicy (pods can talk to each other inside the same namespace).

* If visibility = `"public"`, only the namespaces are created (no policies applied).

---

## Example Usage

```hcl
module "namespaces_private" {
  source = "./modules/namespaces"

  providers = {
    kubernetes = kubernetes
  }

  application_name = "nginx"
  environments     = ["staging", "prod"]
  visibility       = "private"
}

module "namespaces_public" {
  source = "./modules/namespaces"

  providers = {
    kubernetes = kubernetes
  }

  application_name = "nginx"
  environments     = ["staging", "prod"]
  visibility       = "public"
}
```

### Resulting namespaces

* For private:

  * `nginx-int-staging`
  * `nginx-int-prod`
* For public:

  * `nginx-ext-staging`
  * `nginx-ext-prod`

---

## Notes

* This module assumes a working **Kubernetes provider** is configured in your root Terraform.
* For private namespaces, you can extend the module to add more fine-grained `NetworkPolicies` if needed (e.g., allow DNS or outbound APIs).
