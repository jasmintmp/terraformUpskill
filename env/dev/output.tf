#--------- DataSource ------------------------
#  Data from:  provider, HTTP url, ...  , filters
#---------------------------------------------

data "aws_vpcs" "vpc_list" {
}


#--------- Outputs ------------------------
#  
#---------------------------------------------
output "vpc_list" {
  value = "${data.aws_vpcs.vpc_list.ids}"
}