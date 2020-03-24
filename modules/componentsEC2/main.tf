# MODULE componentsEC2
# ---------- EC2 	-----------
# Two Virtual Server
# Create EC2 instance with AMI Image (public image) Ubuntu, 18.04 LTS,
# --------------------------
resource "aws_instance" "akrawiec_EC2" {
  count                   = var.ec2_count
  ami                     = var.ec2_ami
  instance_type           = var.ec2_type
  subnet_id               = var.ec2_subnet_ids[count.index]
  vpc_security_group_ids  = [var.ec2_security_group_id]
  key_name                = aws_key_pair.akrawiec_public_key.key_name

  tags = {
    Name = "akrawiec_ec2_${count.index}"
    Owner = "akrawiec"
    Terraform = true
  }
  #---------- Script fired on launching EC2 --- not working
  //  user_data = file("../../scripts/install_apache.sh")  
}