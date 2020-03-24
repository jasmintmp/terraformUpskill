#  ROOT
#   ├── modules
#   │   └── network, variables.tf, outputs.tf   
#   │   └── componentsEC2, variables.tf, outputs.tf
#   │   └── componentsRDS, variables.tf, outputs.tf
#   ├── env
#       ├── dev  
#       │ └── main.tf, variables.tf, outputs.tf
#       ├── prod
#         └── main.tf, variables.tf, outputs.tf

#------------- Modules -------------------------
# Create: two public subnets in differend AZ
# with Internet GT, SG, RT that can access RDS
# Two private subnet RDS in differend AZ 
#----------------------------------------------
module "network" {
  source = "./../../modules/network"
  vpc_cidr = var.vpc_cidr
  pub_subnet_count = length(var.availability_zone_names)
  prv_subnet_count = var.rds_amount
  availability_zone_names = var.availability_zone_names
}

#--------------------------------
# Create: two EC2
#--------------------------------
module "componentsEC2" {
  source = "./../../modules/componentsEC2"
  ec2_count = length(var.availability_zone_names)
  //ec2_count = 0
  ec2_subnet_ids = module.network.ec2_subnet_ids
  ec2_security_group_id = module.network.ec2_sg_id
}

#--------------------------------
# Create: two RDS 
#--------------------------------
module "componentsRDS" {
  source = "./../../modules/componentsRDS"
  createInstance = var.create_rds_instance
  createReplica = var.create_rds_replica
  rds_subnet_group_id = module.network.rds_subnet_group_id
  rds_security_group_ids = module.network.rds_security_group_ids

  #tags Environment = "dev"
}