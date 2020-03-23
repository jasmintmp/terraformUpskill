# MODUL components
#---------- InPut  ------------
# 
#-------------------------------
variable "EC2subnetId1" {
   description = "subnetId1"
}

variable "EC2subnetId2" {
   description = "subnetId2"
}

variable "EC2securityGroupId" {
   description = "securityGroup"
}

# ---------- Key Pair ----------
# Set up in AWS your public key to allow putty access 
# ------------------------------
resource "aws_key_pair" "akrawiec_public_key" {
  key_name   = "AWS_EC2_public"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAmaKu47XByOz8jyRyCv0ags/XGMu5YDacJah0kf3TZniSQ+AzFJ4MtBDYPaxKNgE29dbZNu2skP66H33VfLwLQZtoWb3Wo7Y24orrrk1k4PrE3JL6p5jinYCXBHJscWscnoTiYzEEV0LzxfsfBsn2VTXPcI2aJSj1PHvph7TQNwhmQ8VhG30Ml0mx1kU21ti/Iazuc93l3jlyQUlt+VQGKYZ0ItEeiS6IMwNewCCKdZlSgBVa3LjRvN6tRZJ+6DziRACoKuVnd8C4gGtXzr2/hurqpCJI3NAeSUI9vrC1aD9VxsdsDEtqzey2Y4HdOMuW7HtgDyHjmttY+ydOivz7hQ== rsa-key-20200318"
}

# ---------- EC2 	-----------
# Two Virtual Server
# Create EC2 instance with AMI Image (public image) Ubuntu, 18.04 LTS,
# --------------------------
resource "aws_instance" "akrawiec_EC2_1" {
  ami           = "ami-06d51e91cea0dac8d"
  instance_type = "t2.micro"
  subnet_id     = var.EC2subnetId1
  vpc_security_group_ids = [var.EC2securityGroupId]
  key_name = aws_key_pair.akrawiec_public_key.key_name

  tags = {
    Name = "akrawiec_EC2_1"
    Owner = "akrawiec"
    Terraform = true
  }
  #---------- Script fired on launching EC2 --- not working
  //  user_data = file("../../scripts/install_apache.sh")  
}

resource "aws_instance" "akrawiec_EC2_2" {
  ami           = "ami-06d51e91cea0dac8d"
  instance_type = "t2.micro"
  subnet_id     = var.EC2subnetId2
  vpc_security_group_ids = [var.EC2securityGroupId]
  key_name = aws_key_pair.akrawiec_public_key.key_name

  tags = {
    Name = "akrawiec_EC2_2"
    Owner = "akrawiec"
    Terraform = true
  }
}

#---------- OutPut  -----------
# 
#-------------------------------
output "publicIpEc1" {
  value = aws_instance.akrawiec_EC2_1.public_ip
}

output "publicIpEc2" {
  value = aws_instance.akrawiec_EC2_2.public_ip
}
