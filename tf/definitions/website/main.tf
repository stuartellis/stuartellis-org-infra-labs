# SPDX-FileCopyrightText: 2024-present Stuart Ellis <stuart@stuartellis.name>
#
# SPDX-License-Identifier: MIT

terraform {
  required_version = "> 1.0.0"

  backend "http" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.48.0"
    }
  }
}
