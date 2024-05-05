# SPDX-FileCopyrightText: 2024-present Stuart Ellis <stuart@stuartellis.name>
#
# SPDX-License-Identifier: MIT

resource "aws_ssm_parameter" "stack_present" {
  name  = "/stacks/${var.product_name}/${var.stack_name}/${var.environment_name}/url"
  type  = "String"
  value = "https://${var.site_name}.${var.domain_name}"
}
