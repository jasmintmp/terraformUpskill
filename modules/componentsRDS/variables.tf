# TAGs
variable "environment" {
}
variable "owner" {
}

# Infra
variable "create_instance" {
  type = bool
}
variable "create_replica" {
  type = bool
}
variable "rds_subnet_group_id" {
   description = "subnetId"
}
variable "rds_security_group_ids" {
   description = "List of security groups master and replica"
}

# predefinied
variable "instance_name" {
   default = "server-myssql-instance"  
}
variable "storage_type" {
    default = "gp2"
}
variable "allocated_storage" {
    default = 20
}
variable "engine" {
    default = "mysql"
}
variable "engine_version" {
    default = "5.7"
}
variable "instance_class" {
    default = "db.t2.micro"
}
variable "username" {
    default = "admin"
}
variable "password" {
    default = "password"
}
variable "port" {
    default = "3306"
}
variable "parameter_group_name" {
    default = "default.mysql5.7"
}
variable "backup_retention_period" {
    default = 1
}
variable "skip_final_snapshot" {
  default = true
}
variable "apply_immediately" {
    default = true
}


