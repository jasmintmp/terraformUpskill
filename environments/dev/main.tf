#  ROOT
#   ├── modules
#   │   └── network
#   │     └── main.tf
#   │   └── components
#   │     └── main.tf
#   │
#   ├── environments
#   │   ├── dev -------------------< 
#   │   │ └── main.tf
#   │   │ └── variables.tf
#   │   ├── production
#   │   │ └── main.tf
#   │   │ └── variables.tf
#   │   └── staging
#   │     └── main.tf
#   │     └── variables.tf
#   │
#─> └── main.tf 

# to the file add ex cid etc..
variable "region" {
  
}

#------------- variables from tfvars ----
variable "serv_count" {
  description   = "A numerical var"
  default = 1
}

# ---------- Provider ----------
# Getting Started
# This is introduction script for terraform with basic commands.
# ------------------------------
provider "aws" {
  profile = "default"
  region  = var.region
}



#----------- Backend Configuration --------------
# First S3 must be created from panel, 
# Configuration is moved to remote state [init];  destroy:  remove .terraform/ 
# The Terraform state is written to the key
# It's used to read state from one place - hence script can be run undependetly from different localizations.
#---------------------------------------------------

terraform {
  backend "s3" {
    bucket = "akrawiec-terraform-state"
    key    = "backend/key"
    region  = "us-west-2"
  }
}



#------------- Modules ----------
module "network" {
  source = "./../../modules/network"
}

module "components" {
  source = "./../../modules/components"
  subnetId = module.network.subnetId
}


# ---------- S3 for test upload --------------
# New resource for the S3 bucket our application will use.
# NOTE: S3 bucket names must be unique across _all_ AWS accounts  
# "my_bucket": local name can be refered from elsewhere in the same module.
# ---------- 

resource "aws_s3_bucket" "my_bucket" {  
  region  = var.region
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




	
#--------- DataSource ------------------------
#  Data from:  provider, HTTP url, ...  , filters
#---------------------------------------------

data "aws_vpcs" "vpc_list" {
}

output "vpc_list" {
  value = "${data.aws_vpcs.vpc_list.ids}"
}








