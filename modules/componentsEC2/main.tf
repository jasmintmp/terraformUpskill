# MODULE componentsEC2 
# ---------- EC2 	---------------------
# Virtual Servers in Autoscaling Group
# based on launc_configuration
# -------------------------------------
# Launch Configuration EC2 parameters
resource "aws_launch_configuration" "this" {
  name          = "${var.owner}-launch-config"
  image_id      = var.ec2_ami
  instance_type = var.ec2_type
  security_groups      = [var.ec2_security_group_id]
  key_name             = aws_key_pair.this.key_name

  lifecycle {
    create_before_destroy = true
  }
}
# Autoscaling Group
resource "aws_autoscaling_group" "this" {
  name                 = "${var.owner}-auto-s-group"
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = var.ec2_subnet_ids 
  
  desired_capacity     = 2
  min_size             = 1
  max_size             = 3
 
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true

  lifecycle {
    create_before_destroy = true
  }

   tags = [
     {
      "key" = "Name"
      "value" = "${var.owner}-ec2-temp"
      "propagate_at_launch" = true
     },

    {
    "key" = "Owner"
    "value" = var.owner
    "propagate_at_launch" = true
  },
  {
    "key" = "Terraform"
    "value" = "true"
    "propagate_at_launch" = true
  },
   ]
}
# Schedule 1 - decrease all to ec2 to 1, every 10 min 
resource "aws_autoscaling_schedule" "decrease" {
  scheduled_action_name  = "decrease"
  desired_capacity       = 1
  min_size               = 1
  max_size               = 1
  start_time             = timeadd(timestamp(), "1h")
  end_time               = "2020-12-12T06:00:00Z"
  recurrence ="* */10 * * *"
  autoscaling_group_name = aws_autoscaling_group.this.name

   lifecycle {
    create_before_destroy = true
  }
}

# Schedule 2 - increase all to ec2 to 2, every 10 min (started 5 min later) 
resource "aws_autoscaling_schedule" "increase" {
  scheduled_action_name  = "increase"
  desired_capacity       = 3
  min_size               = 3
  max_size               = 3
  start_time             = timeadd(timestamp(), "1h5m")
  end_time               = "2020-12-12T06:00:00Z"
  recurrence ="* */7 * * *"
  autoscaling_group_name = aws_autoscaling_group.this.name

   lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_autoscaling_schedule.decrease]
}