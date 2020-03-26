# TerraformUpskill
PGS upskill program
Assumption
https://github.com/jasmintmp/terraformUpskill/blob/master/aws_infrastructure.jpg

Result
https://github.com/jasmintmp/terraformUpskill/blob/master/terraform_upskill_console2.jpg


# VPC 
VPC with Internet Access with  
  Internet Gataway
  Subnets
  Subnets Group for RDS
  Route Table
  
# Security  
	NACL
	Public Security Group EC2 (each)
	Private Security Group RDS (Inboud Rule for RDS <- EC2)
	Route Table + IGW Route
	
# Components
  Multiple EC2 with separate subnet and security group, extended to Autoscaling Group
  RDS with replication in different AZ

# Multiple environment support
  Partial Configuration
  Each switching environment must be preceded following commands:
  ```
  $env=dev or prod
  $terraform init -backend-config=config/backend-${env}.conf -reconfigure
  ```
# Preconditions
	AWS Console
	- AWS Account
	- AWS S3 Bucket for Terraform state
	- AWS Key Pairs to pass SSH key to EC2 
	SYSTEM: 
	- configured AWS profile
	- installed AWS CLI
	- installed Terraform CLI
	- configure Terraform profile (provider)
	
# Apply
	Open bash terminal.
	$bash apply-prod.sh or apply-dev.sh
	
# Destroy	
	```
	$echo $env
	$terraform destroy -var-file=config/${env}.tfvars
	```	
# Tests
  SSH authentication with RSA Public Key on AWS
  Putty connection to EC2 Linux Ubuntu:
    Internet connection
 - $curl http://google.com HTTP:80
   DB connection
 - $telnet enpoint-myssql-replica.cveqos66v3sg.us-west-2.rds.amazonaws.com 3306
  
# Issue diagnostic / option    
    - AWS logs from VPC vpcflowlogs
    - Linux EC2 var/log/cloud-init.log
