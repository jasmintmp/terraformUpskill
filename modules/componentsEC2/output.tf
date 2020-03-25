data "aws_instances" "test" {
  instance_tags = {
    Owner = var.owner
    Terraform = true
  }
    depends_on = [aws_autoscaling_group.this]
}

output "ec2_public_ips" {
  value = data.aws_instances.test.public_ips
}