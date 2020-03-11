#------------- variables ----------------- 
# Passed from .tfvars - the same name ----
#-----------------------------------------

variable "region" {
    description   = "Dev region"
    default = ""
}

variable "Ec2_instances" {
  description   = "A numerical var"
  default = 1
}