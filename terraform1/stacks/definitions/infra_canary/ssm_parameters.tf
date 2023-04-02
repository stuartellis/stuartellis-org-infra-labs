resource "aws_ssm_parameter" "stack_present" {
  name  = "/stacks/${var.product_name}/${var.stack_name}/${var.environment}/${local.variant}"
  type  = "String"
  value = "true"
}
