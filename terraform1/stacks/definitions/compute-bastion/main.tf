terraform {
  required_version = "> 1.0.0"

  backend "http" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.16.1"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.2"
    }
  }
}
