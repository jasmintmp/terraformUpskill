output "ec2_subnet_ids" {
  value = aws_subnet.akrawiec_subnet_pub.*.id
}
output "ec2_sg_id" {
  value = aws_security_group.akrawiec_sg_pub.id
}
output "rds_subnet_group_id" {
  value = aws_db_subnet_group.akrawiec_subnets_group.id
}
output "rds_security_group_ids" {
  value = aws_security_group.akrawiec_sg_prv.*.id
}