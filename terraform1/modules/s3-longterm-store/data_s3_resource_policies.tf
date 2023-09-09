data "aws_iam_policy_document" "longterm" {
  statement {
    sid       = "DenyUnecryptedObjectUploads"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.longterm.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values = [
        "true"
      ]
    }
  }

  statement {
    sid       = "DenyHttpRequests"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.longterm.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }

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
      aws_s3_bucket.longterm.arn,
      "${aws_s3_bucket.longterm.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = var.s3_store_rw_access_role_arns
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        var.aws_account_id
      ]
    }
  }
}
