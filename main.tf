#  ROOT
#   ├── modules
#   │   └── network   
#   │   └── componentsEC2
#   │   └── componentsRDS
#   └─ main.tf, .., dev.tfvars, prod.tfvars

#----------- Backend Configuration --------------
# First S3 must be created from panel, 
# Configuration is moved to remote state [init];  destroy:  remove .terraform/ 
# The Terraform state is written to the key
# It's used to read state from one place - hence script can be run undependetly from different localizations
# Optional add lock table like DynamoDB
#---------------------------------------------------
terraform {
  required_version = "~> 0.12"
  backend "s3" {
  }
}

# ---------- Provider ----------
# Getting Started
# This is introduction script for terraform with basic commands.
# ------------------------------
provider "aws" {
  profile = "default"
  region  = var.region
}

# # ---------- Key Pair ----------
# # Set up in AWS your public key to allow putty access
# # Uncomment when run firs time  
# # ------------------------------
# resource "aws_key_pair" "this" {
#   key_name   = "${var.owner}-public-key"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAmaKu47XByOz8jyRyCv0ags/XGMu5YDacJah0kf3TZniSQ+AzFJ4MtBDYPaxKNgE29dbZNu2skP66H33VfLwLQZtoWb3Wo7Y24orrrk1k4PrE3JL6p5jinYCXBHJscWscnoTiYzEEV0LzxfsfBsn2VTXPcI2aJSj1PHvph7TQNwhmQ8VhG30Ml0mx1kU21ti/Iazuc93l3jlyQUlt+VQGKYZ0ItEeiS6IMwNewCCKdZlSgBVa3LjRvN6tRZJ+6DziRACoKuVnd8C4gGtXzr2/hurqpCJI3NAeSUI9vrC1aD9VxsdsDEtqzey2Y4HdOMuW7HtgDyHjmttY+ydOivz7hQ== rsa-key-20200318"
# }

#------------- Modules -------------------------
# Create: two public subnets in differend AZ
# with Internet GT, SG, RT that can access RDS
# Two private subnet RDS in differend AZ 
#----------------------------------------------
module "network" {
  source = ".//modules/network"
  environment = var.environment
  owner = var.owner
  vpc_cidr = var.vpc_cidr
  az_names = var.az_names
  pub_subnet_count = length(var.az_names)

}

#--------------------------------
# Create: EC2 depending on AZ number
#--------------------------------
module "componentsEC2" {
  source = ".//modules/componentsEC2"
  environment = var.environment
  owner     = var.owner
  ec2_ami   = var.ec2_ami
  ec2_type  = var.ec2_type
  ec2_subnet_ids = module.network.ec2_subnet_ids
  ec2_security_group_id = module.network.ec2_sg_id
  aws_ssh_key_name = var.public_key_name
}

#--------------------------------
# Create: two RDS 
#--------------------------------
module "componentsRDS" {
  source = ".//modules/componentsRDS"
  environment = var.environment
  owner       = var.owner
  username    = var.username
  password    = var.password
  allocated_storage = var.allocated_storage

  create_instance = var.create_rds_instance
  create_replica = var.create_rds_replica
  rds_subnet_group_id = module.network.rds_subnet_group_id
  rds_security_group_ids = module.network.rds_security_group_ids
}