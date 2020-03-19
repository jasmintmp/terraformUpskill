# MODUL network
variable "vpc_cidr" {
}
variable "cidr_subnet_list" {
    type = list(string)

}
variable "availability_zone_names" {
  type = list(string)
  default =["us-west-2"]
}

# -------------- VPC ----------------------
# VPC comes with a default security group, unless it'll be provided.
# VPC restriction on profile = 1
#------------------------------------------
resource "aws_vpc" "akrawiec_vpc" {
  cidr_block      = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "akrawiec_vpc"
    Owner = "akrawiec"
    Terraform = "true"
  }
}

# -------------- Subnet ----------------------
#  Subnet_1 251 IP 2a AZ
#---------------------------------------------
resource "aws_subnet" "akrawiec_subnet_pub_2a" {
  vpc_id     = aws_vpc.akrawiec_vpc.id
  cidr_block = var.cidr_subnet_list[0]
  availability_zone = var.availability_zone_names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "akrawiec_subnet_pub_2a"
    Owner = "akrawiec"
    Terraform = "true"
  }
}

# -------------- Subnet ----------------------
#  Subnet_2 251 IP 2c AZ
#---------------------------------------------
resource "aws_subnet" "akrawiec_subnet_pub_2c" {
  vpc_id     = aws_vpc.akrawiec_vpc.id
  cidr_block = var.cidr_subnet_list[1]
  availability_zone = var.availability_zone_names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "akrawiec_subnet_pub_2c"
    Owner = "akrawiec"
    Terraform = "true"
  }
}

# -------------- Security Group -----------
# Security Group - instance firewall 
# Statefull - no need return trip
# -----------------------------------------
resource "aws_security_group" "akrawiec_sg_pub"{
  name = "akrawiec_sg_pub"
  description = "Allow SSH"
  vpc_id = aws_vpc.akrawiec_vpc.id

  # allow ingress of port 22
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow ingress of port 80
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 tags = {
    Terraform = "true"
  }
}

# -------------- NACL ----------------------
# NACL - subnet firewall   Access Controll List
# -----------------------------------------
resource "aws_network_acl" "akrawiec_vpc_nacl" {
  vpc_id = aws_vpc.akrawiec_vpc.id
   subnet_ids = [aws_subnet.akrawiec_subnet_pub_2a.id, aws_subnet.akrawiec_subnet_pub_2c.id]

  # allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

# allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0" 
    from_port  = 80
    to_port    = 80
  }

# allow ingress auxiliary ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

# allow ingress port 443 https
  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }


  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22 
    to_port    = 22
  }

  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80  
    to_port    = 80 
  }
  
  # allow egress auxiliary ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # allow egress port 443 https
  egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  tags = {
    Name = "akrawiec_vpc_nacl"
    Terraform = "true"
  }
}


# -------------- Gateway ----------------------
# Internet Gateway  
# -----------------------------------------
resource "aws_internet_gateway" "akrawiec_vpc_gw" {
  vpc_id = aws_vpc.akrawiec_vpc.id
#TODO associate subnet with Gateway
  tags = {
    Name = "akrawiec_vpc_gw"
    Terraform = "true"
  }
}

# -------------- Route ----------------------
# Route Table  
# -----------------------------------------
resource "aws_route_table" "akrawiec_VPC_route_table" {
  vpc_id = aws_vpc.akrawiec_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.akrawiec_vpc_gw.id
  }
#check if exaggerated
  depends_on = [aws_internet_gateway.akrawiec_vpc_gw]
  
  tags = {
    Name = "akrawiec_VPC_route_table"
    Terraform = "true"
  }
}


# -------------- Create the Internet Access --
# Direct internet traffic to internet gateway 
# --------------------------------------------
resource "aws_route" "akrawiec_VPC_internet_access" {
  route_table_id         = aws_route_table.akrawiec_VPC_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.akrawiec_vpc_gw.id
} 

# Associate the Route Table with the Subnet1
resource "aws_route_table_association" "akrawiec_VPC_rt_with_sub1" {
  subnet_id      = aws_subnet.akrawiec_subnet_pub_2a.id
  route_table_id = aws_route_table.akrawiec_VPC_route_table.id
} 

# Associate the Route Table with the Subnet2
resource "aws_route_table_association" "akrawiec_VPC_rt_with_sub2" {
  subnet_id      = aws_subnet.akrawiec_subnet_pub_2c.id
  route_table_id = aws_route_table.akrawiec_VPC_route_table.id
}

#---------- OutPut  -----------
# 
#-------------------------------
output "subnetId" {
  value = aws_subnet.akrawiec_subnet_pub_2a.id
}
output "securityGroup" {
  value = aws_security_group.akrawiec_sg_pub.id
}

