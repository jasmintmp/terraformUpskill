# MODUL network

# variable "env_name" {
#   vpc_id = "A string var"
# }


# -------------- VPC ----------------------
# Your VPC comes with a default security group.
#------------------------------------------
resource "aws_vpc" "akrawiec_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "akrawiec_vpc"
    Owner = "akrawiec"
  }
}

# -------------- Subnet ----------------------
#  Subnet_1 251 IP 2a
#---------------------------------------------
resource "aws_subnet" "akrawiec_subnet_1" {
  vpc_id     = aws_vpc.akrawiec_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "akrawiec_subnet_1"
     Owner = "akrawiec"
  }
}

# -------------- Subnet ----------------------
#  Subnet_2 251 IP 2c
#---------------------------------------------
resource "aws_subnet" "akrawiec_subnet_2" {
  vpc_id     = aws_vpc.akrawiec_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2c"

  tags = {
    Name = "akrawiec_subnet_2"
     Owner = "akrawiec"
  }
}

# Security group - firewall
# two subnet in one SG
##########################
# Security group with name
##########################

# Gateway

# Route

#---------- OutPut parameters
# Test messaging
output "subnetId" {
  value = aws_subnet.akrawiec_subnet_1.id
}
