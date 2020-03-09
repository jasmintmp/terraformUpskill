# MODUL components

variable "subnetId" {
   description = "subnetId"
}

# ---------- EC2 	
#Create EC2 instance with AMI Image (public image)
#Amazon Machine Images (AMI) EC2
# ----------
resource "aws_instance" "myEc2" {
  ami           = "ami-06d51e91cea0dac8d"
  instance_type = "t3.micro"
  subnet_id     = var.subnetId
  tags = {
    Name = "akrawiec-EC2"
    Owner = "akrawiec"
  }
  
  #running commands/scripts
   provisioner "local-exec" {
    command = "echo ${aws_instance.myEc2.public_ip} > ip_address.txt"
  }
}
