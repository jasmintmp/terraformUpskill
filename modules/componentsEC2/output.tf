output "ec2_public_ips" {
  value = [aws_instance.this.*.public_ip]
}