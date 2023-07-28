
variable "aws_account_id" {
  type = string
}

variable "s3_data_first_transition_days" {
  type = string
}

variable "s3_data_second_transition_days" {
  type = string
}

variable "s3_data_third_transition_days" {
  type = string
}

variable "s3_store_name" {
  type = string
}

variable "s3_store_rw_access_role_arns" {
  type = list(string)
}
