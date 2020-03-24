#------------- variables ----------------- 
# Passed from .tfvars - the same name ----
#-----------------------------------------
variable "availability_zone_names" {
  description = "List of AZ,  determines EC2 instances"
  default = ["us-west-2a","us-west-2c"]
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "create_rds_instance" {
  default = true
}
variable "create_rds_replica" {
  default = true
}
variable "rds_amount" {
  description = "set 2 for master & replica"
  default = 2
}