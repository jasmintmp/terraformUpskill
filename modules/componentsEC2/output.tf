data "aws_instances" "test" {
  instance_tags = {
    Owner = var.owner
    Terraform = true
  }
    depends_on = [aws_autoscaling_group.this]
}

output "public_ips" {
  value = data.aws_instances.test.public_ips
}
output "autoscaling_group_name" {
  value = aws_autoscaling_group.this.name
}

