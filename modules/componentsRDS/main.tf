# MODULE componentsRDS
variable "createInstance" {
  type = bool
}
variable "createReplica" {
  type = bool
}
variable "rds_subnet_group_id" {
   description = "subnetId"
}

variable "rds_security_group_ids" {
   description = "List of security groups master and replica"
}

# -------------- RDS ----------- -----------
# Crate Instance DB Server  (10min) default RT, NACL
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
 
  #availability_zone = "us-west-2a"

  skip_final_snapshot  = true
  db_subnet_group_name = var.rds_subnet_group_id
  vpc_security_group_ids = var.rds_security_group_ids

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

  //https://github.com/terraform-providers/terraform-provider-aws/issues/528
  //create
  replicate_source_db  = aws_db_instance.akrawiec_RDS_master[count.index].arn
  //modify
  //replicate_source_db  = aws_db_instance.akrawiec_RDS_master[count.index].identifier
  
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
  db_subnet_group_name = var.rds_subnet_group_id
  vpc_security_group_ids = var.rds_security_group_ids
  
  maintenance_window = "Mon:00:00-Mon:02:00"
  backup_window = "02:00-04:00"
  backup_retention_period = 1

  #availability_zone = "us-west-2c"

  tags = {
    Name = "akrawiec_RDS_replica"
    Owner = "akrawiec"
    Terraform = true
  }
}

output "rds_instance_endpoints" {
  description = "A list of all cluster instance endpoints"
  value       = [aws_db_instance.akrawiec_RDS_master.*.endpoint, aws_db_instance.akrawiec_RDS_replica.*.endpoint]
}