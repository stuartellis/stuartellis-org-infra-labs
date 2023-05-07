resource "aws_ssm_parameter" "stack_present" {
  name  = "/stacks/${var.product_name}/${var.stack_name}/${var.environment}/${var.variant}/present"
  type  = "String"
  value = "true"
}
