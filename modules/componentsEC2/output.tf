#---------- OutPut  -----------
# 
#-------------------------------
output "ec2_public_ips" {
  value = [aws_instance.akrawiec_EC2.*.public_ip]
}