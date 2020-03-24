output "rds_instance_endpoints" {
  description = "A list of RDS instances endpoints"
  value       = [aws_db_instance.rds_server.*.endpoint, aws_db_instance.rds_server_replica.*.endpoint]
}