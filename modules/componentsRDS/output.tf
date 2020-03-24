output "rds_instance_endpoints" {
  description = "A list of all cluster instance endpoints"
  value       = [aws_db_instance.akrawiec_RDS_master.*.endpoint, aws_db_instance.akrawiec_RDS_replica.*.endpoint]
}