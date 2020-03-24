output "ec2_subnet_ids" {
  value = aws_subnet.public.*.id
}
output "ec2_sg_id" {
  value = aws_security_group.public_sg.id
}
output "rds_subnet_group_id" {
  value = aws_db_subnet_group.this.id
}
output "rds_security_group_ids" {
  value = aws_security_group.this.*.id
}