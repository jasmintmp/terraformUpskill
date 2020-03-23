# MODUL components

variable "RDSsubnetGroupId" {
   description = "subnetId"
}

variable "RDSsecurityGroupId1" {
   description = "securityGroupId"
}

variable "RDSsecurityGroupId2" {
   description = "securityGroupId"
}
# -------------- RDS ----------- -----------
# Crate 2 Instances DB Server  (10min)
# RDS with access from EC2(SecGroup) -> RDS allowed
# -----------------------------------------
resource "aws_db_instance" "akrawiec_RDS_1" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "sqlserver-ex"
  engine_version       = "14.00.3223.3.v1"
  instance_class       = "db.t2.micro"
  name                 = ""
  username             = "admin"
  password             = "password"
  port                 = "1433"
  skip_final_snapshot  = true
  db_subnet_group_name = var.RDSsubnetGroupId
  vpc_security_group_ids = [var.RDSsecurityGroupId1]

  tags = {
    Name = "akrawiec_RDS_1"
    Owner = "akrawiec"
    Terraform = true
  }
}

resource "aws_db_instance" "akrawiec_RDS_2" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "sqlserver-ex"
  engine_version       = "14.00.3223.3.v1"
  instance_class       = "db.t2.micro"
  name                 = ""
  username             = "admin"
  password             = "password"
  port                 = "1433"
  skip_final_snapshot  = true
  db_subnet_group_name = var.RDSsubnetGroupId
  vpc_security_group_ids = [var.RDSsecurityGroupId2]

  tags = {
    Name = "akrawiec_RDS_2"
    Owner = "akrawiec"
    Terraform = true
  }
}