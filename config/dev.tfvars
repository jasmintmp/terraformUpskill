environment = "dev"
owner ="akrawiec"
#VCP
# mumbai 
region = "ap-south-1"
vpc_cidr = "10.0.0.0/16"
az_names = ["ap-south-1a","ap-south-1b"]
#EC2
# AMI Image (public image) Ubuntu, 18.04 LTS
ec2_ami  = "ami-0123b531fc646552f"
ec2_type = "t2.micro"
#RDS
username = "admin"
password = "password"
allocated_storage = 20
public_key_name = "akrawiec-public-key"