variable "environment" {
  type = string
}

variable "product_name" {
  type = string
}

variable "stack_name" {
  type = string
}

variable "variant" {
  type = string
}

variable "tf_exec_role_arn" {
  type = string
}

# FIXME
variable "site-check_lambda_repo_url" {
  type = string
}

variable "site-check_lambda_version" {
  type = string
}
