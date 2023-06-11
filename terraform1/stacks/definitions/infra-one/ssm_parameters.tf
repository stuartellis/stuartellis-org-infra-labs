resource "aws_ssm_parameter" "stack_present" {
  name  = "/stacks/${var.environment}/${var.product_name}/${var.stack_name}/${var.variant}/present"
  type  = "String"
  value = "true"
}

resource "aws_ssm_parameter" "stack_param_one" {
  name  = "/stacks/${var.environment}/${var.product_name}/${var.stack_name}/${var.variant}/one"
  type  = "String"
  value = "ABC0011"
}
