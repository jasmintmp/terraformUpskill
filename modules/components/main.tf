# MODUL components

variable "subnetId" {
   description = "subnetId"
}

# ---------- S3 for test upload --------------
# New resource for the S3 bucket our application will use.
# NOTE: S3 bucket names must be unique across _all_ AWS accounts  
# "my_bucket": local name can be refered from elsewhere in the same module.
# ---------- 

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
