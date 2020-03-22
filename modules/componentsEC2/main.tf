# MODUL components

variable "EC2subnetId" {
   description = "subnetId"
}

variable "EC2securityGroup" {
   description = "securityGroup"
}

# ---------- S3 for test upload --------------
# New resource for the S3 bucket our application will use.
# NOTE: S3 bucket names must be unique across _all_ AWS accounts  
# "my_bucket": local name can be refered from elsewhere in the same module.
# ------------------------------------------- 
resource "aws_s3_bucket" "my_bucket" {  
  region  = "us-west-2"
  bucket = "akrawiec-terraform-upload"
  acl    = "private"
  force_destroy = true
}

#------------ File upload to S3 --------------
#-- after my_bucket.id has created - referer to .id
# resource "aws_s3_bucket_object" "file_upload" {
#   bucket = aws_s3_bucket.my_bucket.id
#   key    = "my_files.zip"
#   source = "${path.module}/my_files.zip"
#   etag   = filemd5("${path.module}/my_files.zip")
# }

# ---------- Key Pair ----------
# Set up in AWS your public key to allow putty access 
# ------------------------------
resource "aws_key_pair" "akrawiec_public_key" {
  key_name   = "AWS_EC2_public"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAmaKu47XByOz8jyRyCv0ags/XGMu5YDacJah0kf3TZniSQ+AzFJ4MtBDYPaxKNgE29dbZNu2skP66H33VfLwLQZtoWb3Wo7Y24orrrk1k4PrE3JL6p5jinYCXBHJscWscnoTiYzEEV0LzxfsfBsn2VTXPcI2aJSj1PHvph7TQNwhmQ8VhG30Ml0mx1kU21ti/Iazuc93l3jlyQUlt+VQGKYZ0ItEeiS6IMwNewCCKdZlSgBVa3LjRvN6tRZJ+6DziRACoKuVnd8C4gGtXzr2/hurqpCJI3NAeSUI9vrC1aD9VxsdsDEtqzey2Y4HdOMuW7HtgDyHjmttY+ydOivz7hQ== rsa-key-20200318"
}

# ---------- EC2 	-----------
# Virtual Server
# Create EC2 instance with AMI Image (public image) Ubuntu, 18.04 LTS,
# --------------------------
resource "aws_instance" "akrawiec_EC2_1" {
  ami           = "ami-06d51e91cea0dac8d"
  instance_type = "t2.micro"
  subnet_id     = var.EC2subnetId
  vpc_security_group_ids = [var.EC2securityGroup]
  key_name = aws_key_pair.akrawiec_public_key.key_name

  tags = {
    Name = "akrawiec_EC2_1"
    Owner = "akrawiec"
    Terraform = true
  }
  #---------- Script fired on launching EC2 --- not working
    user_data = file("../../scripts/install_apache.sh")  
}

#---------- OutPut  -----------
# 
#-------------------------------
output "publicIpEc1" {
  value = aws_instance.akrawiec_EC2_1.public_ip
}
