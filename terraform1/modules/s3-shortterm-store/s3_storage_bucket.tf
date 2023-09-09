resource "aws_s3_bucket" "shortterm" {
  bucket = var.s3_store_name
}

resource "aws_s3_bucket_versioning" "shortterm" {
  bucket = aws_s3_bucket.shortterm.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "shortterm" {
  bucket = aws_s3_bucket.shortterm.id
  rule {
    id     = "remove_expired_objects"
    status = "Enabled"
    expiration {
      days = var.s3_data_retention_days
    }
  }
}

resource "aws_s3_bucket_policy" "shortterm" {
  bucket = aws_s3_bucket.shortterm.id
  policy = data.aws_iam_policy_document.shortterm.json
}
