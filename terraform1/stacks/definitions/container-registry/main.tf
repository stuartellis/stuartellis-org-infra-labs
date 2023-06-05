terraform {
  required_version = "> 1.0.0"

  backend "http" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.1.0"
    }
  }
}
