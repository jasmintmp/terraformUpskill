#------------- variables -------------------- 
# Can be set in .tfvars - the same name
#--------------------------------------------
variable "environment" {
}
variable "owner" {
}
variable "region" {
}
variable "vpc_cidr" {
}
#network module
variable "az_names" {
  description = "List of AZ,  determines EC2 instances"
}
variable "ec2_ami" {
}
variable "ec2_type" {
   default = "t2.micro"
}

variable "public_key_name" {
}

#rds module, to tourn off set 2xfalse
variable "create_rds_instance" {
  default = true
}
variable "create_rds_replica" {
  default = true
}
variable "username" {
}
variable "password" {
}
variable "allocated_storage" {
}