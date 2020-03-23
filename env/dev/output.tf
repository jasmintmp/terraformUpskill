#--------- DataSource ------------------------
#  Data from:  provider, HTTP url, ...  , filters
#---------------------------------------------
data "aws_vpcs" "vpc_list" {
}

output "vpc_list" {
  value = "${data.aws_vpcs.vpc_list.ids}"
}

output "publicIpEc1" {
  value = module.componentsEC2.publicIpEc1
}

output "publicIpEc2" {
  value = module.componentsEC2.publicIpEc2
}