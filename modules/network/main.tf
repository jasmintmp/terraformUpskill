# MODUL network

variable "cidr_block_vpc" {
}

variable "cidr_block_sub" {
}

variable "az1" {
}
variable "az2" {
}


# -------------- VPC ----------------------
# Your VPC comes with a default security group.
#------------------------------------------
resource "aws_vpc" "akrawiec_vpc" {
  cidr_block      = var.cidr_block_vpc
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
  cidr_block = var.cidr_block_sub
  availability_zone = var.az1
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
  cidr_block = var.cidr_block_sub
  availability_zone = var.az2

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
