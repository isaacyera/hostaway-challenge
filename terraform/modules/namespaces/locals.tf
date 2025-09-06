locals {
  prefix = var.visibility == "private" ? "int" : "ext"

  # env -> "<app>-<prefix>-<env>"
  namespaces = {
    for env in var.environments : env => "${var.application_name}-${local.prefix}-${env}"
  }

  is_private = var.visibility == "private"
}
