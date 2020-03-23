# terraformUpskill
PGS upskill program

https://trello.com/1/cards/5e25becd3165e1581f2fb7ab/attachments/5e30055c97c93c5710104eae/previews/download?backingUrl=https%3A%2F%2Ftrello-attachments.s3.amazonaws.com%2F5e25becd3165e1581f2fb7ab%2F712x1152%2F32468cab569fdc9408123baa473f4216%2Fimage.png


# VPC 
VPC with Internet Access with two or more EC2 with separate subnet and security group
  Internet Gataway
  Subnets
  Subnets Group for RDS
# Security  
	NACL
	Security Group,
	Route Table + itg Route.

# Tests
  SSH authentication with RSA Public Key on AWS
  Putty connection to EC2 Linux Ubuntu:
    Internet connection
 - $curl http://google.com HTTP:80
   DB connection
 - $telnet akrawiec-myssql-replica.cveqos66v3sg.us-west-2.rds.amazonaws.com 3306
  
# Issue diagnostic / option    
    - AWS logs from VPC vpcflowlogs
    - Linux EC2 var/log/cloud-init.log

 
