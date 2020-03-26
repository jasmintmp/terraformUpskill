#TAGs
variable "environment" {
}
variable "owner" {
}
variable "pub_subnet_name" {
  default = "subnet-pub"
}
variable "prv_subnet_name" {
  default = "subnet-prv"
}
variable "pub_sg_name" {
  default = "sg-pub"
}
variable "prv_sg_name" {
  default = "sg-prv"
}
#Infra
variable "vpc_cidr" {
}
variable "pub_subnet_count" {
  type = number
}
variable "prv_subnet_count" {
  description = "set 2 for master & replica"
  default = 2
}
variable "az_names" {
  type = list(string)
}
variable "ingress_pub_ports" {
  type        = list(number)
  description = "list of ingress EC2 access ports"
  default     = [22, 80, 443]
}
variable "ingress_prv_ports" {
  type        = list(number)
  description = "list of ingress RDS access ports"
  default     = [22, 3306]
}
variable "ingress_ports_nacl" {
  description = "map of ingress nacl ports"
  default     = {
      "100" = 22
      "200" = 80
      "400" = 443
      }
}
