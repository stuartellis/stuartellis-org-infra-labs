resource "aws_s3_bucket" "longterm" {
  bucket = var.s3_store_name
}

resource "aws_s3_bucket_versioning" "longterm" {
  bucket = aws_s3_bucket.longterm.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "longterm" {
  bucket = aws_s3_bucket.longterm.id
  rule {
    id     = "archive_older_objects"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.s3_data_third_transition_days
    }

    noncurrent_version_transition {
      noncurrent_days = var.s3_data_first_transition_days
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = var.s3_data_second_transition_days
      storage_class   = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_policy" "longterm" {
  bucket = aws_s3_bucket.longterm.id
  policy = data.aws_iam_policy_document.longterm.json
}
