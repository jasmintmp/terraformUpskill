output "ec2_public_ips" {
  value = module.componentsEC2.public_ips
}

output "rds_instance_endpoints" {
  value = module.componentsRDS.rds_instance_endpoints
}