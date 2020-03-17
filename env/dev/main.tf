#  ROOT
#   ├── modules
#   │   └── network
#   │     └── main.tf
#   │   └── components
#   │     └── main.tf
#   │
#   ├── env
#       ├── dev  
#       │ └── main.tf
#       │ └── variables.tf
#       │ └── outputs.tf
#       ├── prod
#       │ └── main.tf
#       │ └── variables.tf
#       └── staging
#         └── main.tf
#         └── variables.tf




# ---------- Provider ----------
# Getting Started
# This is introduction script for terraform with basic commands.
# ------------------------------
provider "aws" {
  profile = "default"
  region  = var.region
}



#----------- Backend Configuration --------------
# First S3 must be created from panel, 
# Configuration is moved to remote state [init];  destroy:  remove .terraform/ 
# The Terraform state is written to the key
# It's used to read state from one place - hence script can be run undependetly from different localizations.
#---------------------------------------------------

terraform {
  backend "s3" {
    bucket = "akrawiec-terraform-state"
    key    = "backend/key"
    region  = "us-west-2"
  }
}



#------------- Modules ----------
# subnets 10.0.0.x  10.0.1.x 
#--------------------------------

module "network" {
  source = "./../../modules/network"
  cidr_block_vpc = "10.0.0.0/16"
  cidr_block_sub = "10.0.0.0/24"
  az1 = "us-west-2a"
  az2 = "us-west-2c"
}

module "components" {
  source = "./../../modules/components"
  subnetId = module.network.subnetId
}


	









