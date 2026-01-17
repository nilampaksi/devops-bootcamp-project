locals {
  prefix = "${var.project}-final-project"

  common_tags = {
    Project   = var.project
    ManagedBy = "Terraform"
  }
}

