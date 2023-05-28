module "lambda_imgcleaner" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.17.0"

  function_name = "${local.lambda_prefix}-imgcleaner"
  description   = "Image cleaner"

  create_package = false

  image_uri     = "${imgcleaner_lambda_repo_url}:${imgcleaner_lambda_version}"
  package_type  = "Image"
  architectures = ["x86_64"]

}
