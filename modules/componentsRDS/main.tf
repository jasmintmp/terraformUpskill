# MODULE componentsRDS
# -------------- RDS ----------- -----------
# Crate Instance DB Server  (10min) default RT, NACL
# RDS with access from EC2(SecGroup) -> RDS allowed
# -----------------------------------------
resource "aws_db_instance" "rds_server" {
  count = var.createInstance ? 1 : 0

  db_subnet_group_name = var.rds_subnet_group_id
  vpc_security_group_ids = var.rds_security_group_ids

  identifier              = var.instance_name
  username                = var.username
  password                = var.password

  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  port                    = var.port
  parameter_group_name    = var.parameter_group_name
  skip_final_snapshot     = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
  apply_immediately       = var.apply_immediately

  tags = {
  Name = "${var.owner}-rds-instance"
  Terraform = "true"
  Onwer = var.owner
  Environment = var.environment
  }
}

# -------------- RDS ----------- -----------
# Crate DB read replica  (10min)
# -----------------------------------------
resource "aws_db_instance" "rds_server_replica" {
  count = var.createReplica ? 1 : 0

  //create
  replicate_source_db  = aws_db_instance.rds_server[count.index].arn
  
  //modify
  //replicate_source_db  = aws_db_instance.rds_server[count.index].identifier
  
  //not needed if the same region
  //db_subnet_group_name = var.rds_subnet_group_id
  vpc_security_group_ids = var.rds_security_group_ids
  
  identifier              = "${var.instance_name}-replica"
  username                = ""
  password                = ""
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  port                    = var.port
  skip_final_snapshot     = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
  apply_immediately       = var.apply_immediately

  tags = {
  Name = "${var.owner}-rds-instance-replica"
  Terraform = "true"
  Onwer = var.owner
  Environment = var.environment
  }
}