environment = "prod"
owner ="akrawiec"
#VCP
# mumbai 
region = "ap-south-1"
vpc_cidr = "20.0.0.0/16"
az_names = ["ap-south-1a","ap-south-1b"]

#EC2 launch config
# AMI Image (public image) Ubuntu, 18.04 LTS
ec2_ami  = "ami-0123b531fc646552f"
ec2_type = "t2.micro"
ec2_desired_capacity = 2
ec2_min_size = 1
ec2_max_size = 3

# ASG Scheduler
sched1_scheduled_action_name = "decrease"
sched1_desired_capacity =   1
sched1_min_size         =   1
sched1_max_size         =   1
sched1_start_time       =   "1h"
sched1_end_time         =   "2020-12-12T06:00:00Z"
sched1_recurrence       =   "* */10 * * *"

sched2_scheduled_action_name = "increase"
sched2_desired_capacity =   3
sched2_min_size         =   3
sched2_max_size         =   3
sched2_start_time       =   "1h5m"
sched2_end_time         =   "2020-12-12T06:00:00Z"
sched2_recurrence       =   "* */7 * * *"

#RDS
username = "admin"
password = "password"
replica_username = "admin"
replica_password = "password"
allocated_storage = 20
public_key_name = "akrawiec-public-key"