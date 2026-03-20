terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.17, < 6.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 2.0.0, < 3.0.0"
    }
  }
}
