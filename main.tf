terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Change to your region
}

variable "worker_pool_config" { 
    type = string 
    sensitive = true 
    }

variable "worker_pool_private_key" { 
    type = string 
    sensitive = true 
    }

variable "worker_pool_id" { 
    type = string 
    sensitive = true 
    }


module "spacelift_workerpool" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-workerpool-on-ec2?ref=v5.4.2"

  worker_pool_id = var.worker_pool_id  # From Spacelift UI (e.g., "01JXXXXXX")

  secure_env_vars = { 
    SPACELIFT_TOKEN = var.worker_pool_config 
    SPACELIFT_POOL_PRIVATE_KEY = var.worker_pool_private_key 
    }

  # Networking
  vpc_subnets     = [
    "subnet-0f241a2caee4fbc20", 
    "subnet-0e92b8fc3fd8b8a19", 
    "subnet-0a3b7703684a2ed2a"]  # Your subnet(s)
  security_groups = ["sg-04755e0e47b790a31"]       # SG with outbound 443 allowed

  # Sizing
  ec2_instance_type = "t2.xlarge"
  min_size          = 2
  max_size          = 2
}
