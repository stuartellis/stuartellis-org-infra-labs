data "archive_file" "image_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../../python/lambdas/${var.image_function_name}"
  output_path = "${path.module}/${var.image_function_name}.zip"
}

resource "aws_cloudwatch_log_group" "image_lambda" {
  name              = "/aws/lambda/${var.image_function_name}"
  retention_in_days = var.log_retention_days
}

resource "aws_iam_role" "image_lambda" {
  name = "${title(local.lambda_prefix)}ImageLambdaRole"

  inline_policy {
    name = "ImageLambdaPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Effect   = "Allow"
          Resource = "${aws_cloudwatch_log_group.image_lambda.arn}:*"
        }
      ]
    })
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_lambda_function" "image_lambda" {
  description      = "Site checker"
  filename         = data.archive_file.image_lambda_zip.output_path
  function_name    = "${local.lambda_prefix}-${var.image_function_name}"
  handler          = var.handler
  source_code_hash = data.archive_file.image_lambda_zip.output_base64sha256
  runtime          = var.runtime
  role             = aws_iam_role.image_lambda.arn

  environment {
    variables = {
      TARGET_URL = "https://www.stuartellis.name"
    }
  }

  depends_on = [data.archive_file.image_lambda_zip]
}
