# TAGs
variable "environment" {
}
variable "owner" {
}

# Infra
# variable "ec2_count" {
#    description = "Number of EC2 instances"
#    type = number
# }
variable "ec2_subnet_ids" {
   description = "Ordered list of subnets for each EC2"
}
variable "ec2_security_group_id" {
   description = "securityGroup"
}
variable "ec2_ami" {
   description = "AMI Image (public image) Ubuntu, 18.04 LTS"
   default = "ami-06d51e91cea0dac8d"
}
variable "ec2_type" {
   default = "t2.micro"
}