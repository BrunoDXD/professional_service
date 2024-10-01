terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

#Versionamento do tfenv
  required_version = ">= 1.1.7"
}

#Declaração do Provedor
provider "aws" {
  region  = var.region
  
}








