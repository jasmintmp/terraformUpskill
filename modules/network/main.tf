# MODULE network
locals{
  zero-address = "0.0.0.0/0"
}

# -------------- VPC ----------------------
# VPC comes with a default security group, unless it'll be provided.
# VPC restriction on profile = 1
#------------------------------------------
resource "aws_vpc" "this" {
  cidr_block      = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.owner}-vpc"
    Owner = var.owner
    Terraform = true
    Environment = var.environment
  }
}
# --------------------------------------------------------------------------------------------
# EC2 - preparation, public Internet access 
# --------------------------------------------------------------------------------------------
# -------------- Subnet ----------------------
#  Add public subnets - unique CIDR/VPC/AZ cidrsubnet() 
#  10.0.1.0/24, 10.0.2.0/24
#---------------------------------------------
resource "aws_subnet" "public"{
  count = var.pub_subnet_count
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index+1)

  availability_zone = var.availability_zone_names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.owner}-${var.pub_subnet_name}-${count.index}"
    Owner = var.owner
    Terraform = true
    Environment = var.environment
  }
}

# -------------- EC2 Security Group --------
# Add Public Security Group - instance firewall 
# Statefull - no need return trip
# Default SG allows traffic
# -----------------------------------------
resource "aws_security_group" "public_sg"{
  description = "Allow SSH"
  vpc_id = aws_vpc.this.id

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
    Owner = var.owner
    Name = "${var.owner}-${var.pub_sg_name}"
    Terraform = true
    Environment = var.environment
  }
}

# -------------- NACL ----------------------
# Add NACL - subnet firewall  Access Controll List
# Default NACL allows traffic
# -----------------------------------------
resource "aws_network_acl" "public_vpc_nacl" {
  vpc_id = aws_vpc.this.id
  subnet_ids = aws_subnet.public.*.id

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
    Name = "${var.owner}-nacl"
    Terraform = true
    Onwer = var.owner
    Environment = var.environment
  }
}

# --------------------------------------------------------------
#  Create the Internet Access, IGW, RT, Routes, Associations 
#  Remember to allow access NACL(with ephemeral), SecGroups
# --------------------------------------------------------------
# 1 Add Internet Gateway  
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
#TODO associate subnet with Gateway
  tags = {
    Name = "${var.owner}-vpc-gw"
    Terraform = true
    Onwer = var.owner
    Environment = var.environment
  }
}

# 2 Add Route Table : direct internet traffic to internet gateway 
resource "aws_route_table" "vpc_route_table" {
  vpc_id = aws_vpc.this.id
  
  route {
    cidr_block = local.zero-address
    gateway_id = aws_internet_gateway.this.id
  }
  # check if exaggerated
  depends_on = [aws_internet_gateway.this]
  
  tags = {
    Name = "${var.owner}-vpc-route-table"
    Terraform = true
    Onwer = var.owner
    Environment = var.environment
  }
}

# 3 Add Route Table: subnets access to Internet Gateway
resource "aws_route" "vpc_internet_access" {
  route_table_id         = aws_route_table.vpc_route_table.id
  destination_cidr_block = local.zero-address
  gateway_id             = aws_internet_gateway.this.id
} 

# 4 Associate the Route Table with the public Subnets
resource "aws_route_table_association" "vpc_rt_with_subnets" {
  count = length(aws_subnet.public.*.id)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.vpc_route_table.id
}

# --------------------------------------------------------------------------------------------
# RDS - preparation
# --------------------------------------------------------------------------------------------
#------------------------------- 
# 1 Creating two Private Subnets 
# ex: vpc 10.0.0.0/16 10.0.0.3.0/24, 10.0.0.4.0/24 
#-------------------------------
resource "aws_subnet" "subnet_prv" {
  count = var.prv_subnet_count
  vpc_id     = aws_vpc.this.id  
  
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index+1+var.pub_subnet_count)
  availability_zone = var.availability_zone_names[count.index]

  tags = {
    Name = "${var.owner}-${var.prv_subnet_name}-${count.index}"
    Terraform = true
    Owner = var.owner
    Environment = var.environment
  }
}

# -------------- DB Subnet's Group --------
# 2 Crate DB private Subnets Group
# -----------------------------------------
resource "aws_db_subnet_group" "this" {
  subnet_ids = aws_subnet.subnet_prv.*.id

  tags = {
    Name = "${var.owner}-${var.prv_subnet_name}-group"
    Terraform = true
    Owner = var.owner
    Environment = var.environment
  }
}

# -------------- RDS Security Group -----------
# 3.1 Crate master/replica SG, for each rds subnet
# RDS with Source EC2(SecGroup) -> RDS allowed
# -----------------------------------------
resource "aws_security_group" "this"{
  count = var.prv_subnet_count
  description = "Allow EC2 access to RDS"
  vpc_id = aws_vpc.this.id

  dynamic "ingress"{
    iterator = port
    for_each = var.ingress_prv_ports
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      security_groups = [aws_security_group.public_sg.id]
    }
  }

  tags = {
    Name = "${var.owner}-${var.prv_sg_name}"
    Terraform = true
    Environment = var.environment
  }
}