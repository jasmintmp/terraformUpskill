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
# subnets 10.0.a.x  10.0.b.x 
#--------------------------------
module "network" {
  source = "./../../modules/network"
  vpc_cidr = "10.0.0.0/16"
  cidr_subnet_list = ["10.0.101.0/24","10.0.102.0/24"]
  availability_zone_names = ["us-west-2a","us-west-2c"]
}

module "componentsEC2" {
  source = "./../../modules/componentsEC2"
  EC2subnetId = module.network.EC2subnetId
  EC2securityGroup = module.network.EC2securityGroup
}

module "componentsRDS" {
  source = "./../../modules/componentsRDS"
  RDSsubnetGroupId = module.network.RDSsubnetGroupId
  RDSsecurityGroupId = module.network.RDSsecurityGroupId
}