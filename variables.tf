#------------- variables -------------------- 
# Can be set in .tfvars - the same name
#--------------------------------------------
variable "environment" {
}
variable "owner" {
}
variable "region" {
}

#network module
variable "vpc_cidr" {
}
variable "az_names" {
  description = "List of AZ,  determines EC2 instances"
}
# ec2 module
variable "ec2_ami" {
}
variable "ec2_type" {
  description = "AMI Image (public image) Ubuntu, 18.04 LTS"
  default = "ami-06d51e91cea0dac8d"
}
variable "ec2_desired_capacity" {
   default = 2
}
variable "ec2_min_size" {
   default = 1
}
variable "ec2_max_size" {
   default = 3
}

variable "public_key_name" {
}

# ASG schedule module
variable "sched1_scheduled_action_name" {
}
variable "sched1_desired_capacity" {
}
variable "sched1_min_size" {
}
variable "sched1_max_size" { 
}
variable "sched1_start_time" {
}

variable "sched1_end_time" {
}
variable "sched1_recurrence" {
}

variable "sched2_scheduled_action_name" {
}
variable "sched2_desired_capacity" {
}
variable "sched2_min_size" {
}
variable "sched2_max_size" { 
}
variable "sched2_start_time" {
}

variable "sched2_end_time" {
}
variable "sched2_recurrence" {
}

# rds module, to tourn off set 2xfalse
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

variable "replica_username" {
}
variable "replica_password" {
}
variable "allocated_storage" {
}