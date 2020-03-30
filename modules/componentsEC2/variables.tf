# TAGs
variable "environment" {
}
variable "owner" {
}
variable "aws_ssh_key_name"{   
}
variable "subnet_ids" {
   description = "Ordered list of subnets for each EC2"
}
variable "security_group_id" {
   description = "securityGroup"
}
variable "ami" {
}
variable "type" {
}
variable "desired_capacity" {
}
variable "min_size" {
}
variable "max_size" {
}