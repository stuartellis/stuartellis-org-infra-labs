provider "aws" {
  default_tags {
    tags = {
      Environment = var.environment
      Product     = var.product_name
      Provisioner = "Terraform"
      Stack       = var.stack_name
      Variant     = var.variant
    }
  }
}
