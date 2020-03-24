# MODULE componentsEC2
# ---------- EC2 	-----------
# Two Virtual Server
# Create EC2 instance per each subnet
# --------------------------
resource "aws_instance" "this" {
  count                   = var.ec2_count
  ami                     = var.ec2_ami
  instance_type           = var.ec2_type
  subnet_id               = var.ec2_subnet_ids[count.index]
  vpc_security_group_ids  = [var.ec2_security_group_id]
  key_name                = aws_key_pair.this.key_name

  tags = {
    Name = "${var.owner}-ec2-${count.index}"
    Terraform = "true"
    Onwer = var.owner
    Environment = var.environment
    }
  #---------- Script fired on launching EC2 --- not working
  //  user_data = file("../../scripts/install_apache.sh")  
}