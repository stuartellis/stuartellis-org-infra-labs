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

## Lambda variables

variable "image_function_name" {
  description = "Lambda function name"
  type        = string
}

variable "handler" {
  description = "Lambda handler name"
  type        = string
  default     = "app.handler"
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 14
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.11"
}
