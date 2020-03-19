#--------- DataSource ------------------------
#  Data from:  provider, HTTP url, ...  , filters
#---------------------------------------------
data "aws_vpcs" "vpc_list" {
}

output "vpc_list" {
  value = "${data.aws_vpcs.vpc_list.ids}"
}

output "publicIp" {
  value = module.components.publicIpEc1
}