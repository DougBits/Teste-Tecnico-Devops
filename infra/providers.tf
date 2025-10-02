# Primeiramente vamos definir o Provider. 
# Como vamos usar EKS, para já pensar em escalabilidade futura, configuramos dessa forma

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Define a região

provider "aws" {
  region = var.aws_region
}