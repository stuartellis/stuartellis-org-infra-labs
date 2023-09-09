module "lambda_site-check" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.0.0"

  function_name = "${local.lambda_prefix}-site-check"
  description   = "Site checker"

  create_package = false

  image_uri     = "${site-check_lambda_repo_url}:${site-check_lambda_version}"
  package_type  = "Image"
  architectures = ["x86_64"]

}
