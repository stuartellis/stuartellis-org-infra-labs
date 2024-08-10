# SPDX-FileCopyrightText: 2024-present Stuart Ellis <stuart@stuartellis.name>
#
# SPDX-License-Identifier: MIT

provider "aws" {
  default_tags {
    tags = {
      Environment = var.environment_name
      Product     = var.product_name
      Provisioner = "Terraform Test"
      Stack       = var.stack_name
      Variant     = var.variant
    }
  }
}

variables {
  product_name     = "labs"
  stack_name       = "core-config"
  environment_name = "testing"
  variant          = "tftest"
}

run "validate_params_path" {
  command = apply
}
