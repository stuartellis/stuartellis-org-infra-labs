module "s3_bucket_opsfiles" {

  source = "../../../modules/s3-shortterm-store"

  s3_store_name = "${local.s3_bucket_prefix}-ops-${local.s3_bucket_suffix}"

  aws_account_id         = data.aws_caller_identity.current.account_id
  s3_data_retention_days = var.s3_data_retention_days

  s3_store_rw_access_role_arns = [
    var.tf_exec_role_arn
  ]
}
