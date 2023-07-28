module "s3_bucket_testdr" {

  source = "../../../modules/s3-longterm-store"

  s3_store_name = "${local.s3_bucket_prefix}-testdr-${local.s3_bucket_suffix}"

  aws_account_id                 = data.aws_caller_identity.current.account_id
  s3_data_first_transition_days  = var.s3_data_first_transition_days
  s3_data_second_transition_days = var.s3_data_second_transition_days
  s3_data_third_transition_days  = var.s3_data_third_transition_days

  s3_store_rw_access_role_arns = [
    var.var.tf_exec_role_arn
  ]
}
