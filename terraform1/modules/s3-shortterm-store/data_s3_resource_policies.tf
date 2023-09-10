data "aws_iam_policy_document" "shortterm" {

  statement {
    sid    = "AllowAuthorizedRolesRW"
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:AbortMultipartUpload",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListMultipartUploads"
    ]

    resources = [
      aws_s3_bucket.shortterm.arn,
      "${aws_s3_bucket.shortterm.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = var.s3_store_rw_access_role_arns
    }
  }
}
