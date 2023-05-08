locals {
  s3_bucket_prefix = "${var.product_name}-${var.environment}-${var.variant}-${data.aws_caller_identity.this.account_id}"
  s3_bucket_suffix = "${data.aws_region.current.name}"
}
