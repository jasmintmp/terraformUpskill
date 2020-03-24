# MODULE network
locals{
  zero-address = "0.0.0.0/0"
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
    Environment = var.environment
  }
}
# --------------------------------------------------------------------------------------------
# EC2 - preparation, public Internet access 
# --------------------------------------------------------------------------------------------
# -------------- Subnet ----------------------
#  Add public subnets - unique CIDR/VPC/AZ cidrsubnet()
#---------------------------------------------
resource "aws_subnet" "akrawiec_subnet_pub"{
  count = var.pub_subnet_count
  vpc_id     = aws_vpc.akrawiec_vpc.id
  //cidr_block = "10.0.2${count.index}.0/24"
  cidr_block = cidrsubnet(aws_vpc.akrawiec_vpc.cidr_block, 8, count.index+1)

  availability_zone = var.availability_zone_names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "akrawiec_subnet_pub_${count.index}"
    Owner = "akrawiec"
    Terraform = "true"
    Environment = var.environment
  }
}

# -------------- Security Group -----------
# Add Public Security Group - instance firewall 
# Statefull - no need return trip
# Default SG allows traffic
# -----------------------------------------
resource "aws_security_group" "akrawiec_sg_pub"{
  name = "akrawiec_sg_pub"
  description = "Allow SSH"
  vpc_id = aws_vpc.akrawiec_vpc.id

  dynamic "ingress"{
    iterator = port
    for_each = var.ingress_pub_ports
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = [local.zero-address]
    }
  }
  
 tags = {
    Owner ="akrawiec"
    Terraform = "true"
    Environment = var.environment
  }
}

# -------------- NACL ----------------------
# Add NACL - subnet firewall  Access Controll List
# Default NACL allows traffic
# -----------------------------------------
resource "aws_network_acl" "akrawiec_vpc_nacl" {
  vpc_id = aws_vpc.akrawiec_vpc.id
  subnet_ids = aws_subnet.akrawiec_subnet_pub.*.id

  dynamic "ingress"{
    for_each = var.ingress_ports_nacl
    iterator = rule
    content{
      rule_no   = rule.key
      from_port = rule.value
      to_port   = rule.value
      protocol  = "tcp"
      cidr_block= local.zero-address
      action    = "allow"
    }
  }

  dynamic "egress"{
      for_each = var.ingress_ports_nacl
      iterator = rule
      content{
        rule_no   = rule.key
        from_port = rule.value
        to_port   = rule.value
        protocol  = "tcp"
        cidr_block= local.zero-address
        action    = "allow"
      }
    }

  # allow ingress auxiliary ports, Ephemeral Ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block =  local.zero-address
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block =  local.zero-address
    from_port  = 1024
    to_port    = 65535
  }

  tags = {
    Name = "akrawiec_vpc_nacl"
    Terraform = "true"
    Onwer = "akrawiec"
    Environment = var.environment
  }
}

# --------------------------------------------------------------
#  Create the Internet Access, IGW, RT, Routes, Associations 
#  Remember to allow access NACL(with ephemeral), SecGroups
# --------------------------------------------------------------
# 1 Add Internet Gateway  
resource "aws_internet_gateway" "akrawiec_vpc_gw" {
  vpc_id = aws_vpc.akrawiec_vpc.id
#TODO associate subnet with Gateway
  tags = {
    Name = "akrawiec_vpc_gw"
    Terraform = "true"
    Environment = var.environment
  }
}

# 2 Add Route Table : direct internet traffic to internet gateway 
resource "aws_route_table" "akrawiec_VPC_route_table" {
  vpc_id = aws_vpc.akrawiec_vpc.id
  
  route {
    cidr_block = local.zero-address
    gateway_id = aws_internet_gateway.akrawiec_vpc_gw.id
  }
  # check if exaggerated
  depends_on = [aws_internet_gateway.akrawiec_vpc_gw]
  
  tags = {
    Name = "akrawiec_VPC_route_table"
    Terraform = "true"
    Environment = var.environment
  }
}

# 3 Add Route Table: subnets access to Internet Gateway
resource "aws_route" "akrawiec_VPC_internet_access" {
  route_table_id         = aws_route_table.akrawiec_VPC_route_table.id
  destination_cidr_block = local.zero-address
  gateway_id             = aws_internet_gateway.akrawiec_vpc_gw.id
} 

# 4.1 Associate the Route Table with the Subnet1
resource "aws_route_table_association" "akrawiec_VPC_rt_with_sub1" {
  subnet_id      = aws_subnet.akrawiec_subnet_pub[0].id
  route_table_id = aws_route_table.akrawiec_VPC_route_table.id
} 

# 4.2 Associate the Route Table with the Subnet2
resource "aws_route_table_association" "akrawiec_VPC_rt_with_sub2" {
  subnet_id      = aws_subnet.akrawiec_subnet_pub[1].id
  route_table_id = aws_route_table.akrawiec_VPC_route_table.id
}

# --------------------------------------------------------------------------------------------
# RDS - preparation, private subnet.
# --------------------------------------------------------------------------------------------
#------------------------------- 
# 1 Creating two Private Subnets 
#-------------------------------
resource "aws_subnet" "akrawiec_subnet_prv" {
  count = var.prv_subnet_count
  vpc_id     = aws_vpc.akrawiec_vpc.id  
  cidr_block = "10.0.10${count.index}.0/24"
  availability_zone = var.availability_zone_names[count.index]

  tags = {
    Name = "akrawiec_subnet_prv_${count.index}"
    Terraform = true
    Owner = "akrawiec"
    Environment = var.environment
  }
}

# -------------- DB Subnet's Group --------
# 2 Crate DB Subnets Group
# -----------------------------------------
resource "aws_db_subnet_group" "akrawiec_subnets_group" {
  name       = "akrawiec_subnets_group"
  subnet_ids = aws_subnet.akrawiec_subnet_prv.*.id

  tags = {
    Name = "akrawiec DB subnet group"
    Terraform = true
    Owner = "akrawiec"
    Environment = var.environment
  }
}

# -------------- RDS Security Group -----------
# 3.1 Crate master/replica Security Groups block
# RDS with Source EC2(SecGroup) -> RDS allowed
# -----------------------------------------
resource "aws_security_group" "akrawiec_sg_prv"{
  count = var.prv_subnet_count
  name = "akrawiec_sg_prv_${count.index}"
  description = "Allow EC2 access to RDS"
  vpc_id = aws_vpc.akrawiec_vpc.id

  dynamic "ingress"{
    iterator = port
    for_each = var.ingress_prv_ports
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      security_groups = [aws_security_group.akrawiec_sg_pub.id]
    }
  }

  tags = {
    Name = "RDS private Security Group"
    Terraform = true
    Environment = var.environment
  }
}