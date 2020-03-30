# MODULE componentsEC2 
locals {
  standard_tags = {
    Name      = "${var.owner}-ag"
    Owner     = var.owner
    Environment = var.environment
    Terraform = true
  }
}
# ---------- EC2 	---------------------
# Virtual Servers in Autoscaling Group
# based on launch_configuration, can't change-immutable
# -------------------------------------
# Launch Configuration EC2 parameters
resource "aws_launch_configuration" "this" {
  name_prefix     = "${var.owner}-launch-config"
  image_id        = var.ami
  instance_type   = var.type
  security_groups = [var.security_group_id]
  key_name        = var.aws_ssh_key_name

  lifecycle {
    create_before_destroy = true
  }
}

# Autoscaling Group
resource "aws_autoscaling_group" "this" {
  name_prefix           = "${var.owner}-auto-sg"
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = var.subnet_ids 
  
  desired_capacity     = var.desired_capacity
  min_size             = var.min_size
  max_size             = var.max_size
 
  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = local.standard_tags
    content{
      key   = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }
}