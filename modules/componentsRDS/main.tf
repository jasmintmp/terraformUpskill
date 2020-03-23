# MODUL components
variable "createInstance" {
  type = bool
}
variable "createReplica" {
  type = bool
}
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
# Crate Instance DB Server  (10min)
# RDS with access from EC2(SecGroup) -> RDS allowed
# -----------------------------------------
resource "aws_db_instance" "akrawiec_RDS_master" {
  count = var.createInstance ? 1 : 0
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "akrawiec-myssql-master"
  username             = "admin"
  password             = "password"
  port                 = "3306"
  parameter_group_name = "default.mysql5.7"
 
  availability_zone = "us-west-2a"

  skip_final_snapshot  = true
  db_subnet_group_name = var.RDSsubnetGroupId
  vpc_security_group_ids = [var.RDSsecurityGroupId1]

  maintenance_window = "Mon:00:00-Mon:02:00"
  backup_window = "02:00-04:00"
  backup_retention_period = 1
  apply_immediately       = true

  tags = {
    Name = "akrawiec_RDS_master"
    Owner = "akrawiec"
    Terraform = true
  }
}

# -------------- RDS ----------- -----------
# Crate DB read replica  (10min)
# -----------------------------------------
resource "aws_db_instance" "akrawiec_RDS_replica" {
  count = var.createReplica ? 1 : 0
  #replicate_source_db  = aws_db_instance.akrawiec_RDS_master[count.index].identifier
  #Amazon Resource Name - AWS bug
  replicate_source_db  = aws_db_instance.akrawiec_RDS_master[count.index].arn
  
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "akrawiec-myssql-replica"
  username             = ""
  password             = ""
  port                 = "3306"
  skip_final_snapshot  = true
  db_subnet_group_name = var.RDSsubnetGroupId
  vpc_security_group_ids = [var.RDSsecurityGroupId2]
  
  maintenance_window = "Mon:00:00-Mon:02:00"
  backup_window = "02:00-04:00"
  backup_retention_period = 1

  availability_zone = "us-west-2c"

  tags = {
    Name = "akrawiec_RDS_replica"
    Owner = "akrawiec"
    Terraform = true
  }
}