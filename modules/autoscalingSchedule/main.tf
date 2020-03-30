# Schedule module 
resource "aws_autoscaling_schedule" "decrease" {
  scheduled_action_name  = var.scheduled_action_name
  desired_capacity       = var.desired_capacity
  min_size               = var.min_size
  max_size               = var.max_size
  start_time             = var.start_time
  end_time               = var.end_time
  recurrence             = var.recurrence
  autoscaling_group_name = var.autoscaling_group_name

   lifecycle {
    create_before_destroy = true
  }
}