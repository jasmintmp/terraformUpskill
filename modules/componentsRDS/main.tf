# MODUL components

variable "RDSsubnetGroupId" {
   description = "subnetId"
}

variable "RDSsecurityGroupId" {
   description = "securityGroupId"
}

# -------------- RDS ----------- -----------
# Crate Instance DB Server  (10min)
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
  vpc_security_group_ids = [var.RDSsecurityGroupId]

  tags = {
    Name = "akrawiec_RDS_1"
    Owner = "akrawiec"
    Terraform = true
  }
}
