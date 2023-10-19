# Creating the autoscaling launch configuration that contains AWS EC2 instance details

resource "aws_launch_configuration" "jack-launch-config" {
# Defining the name of the Autoscaling launch configuration
  name          = "jack-etclinic-asg"
# Defining the image ID of AWS EC2 instance
  image_id      = var.image
# Defining the instance type of the AWS EC2 instance
  instance_type = "t2.micro"
# Defining the Key that will be used to access the AWS EC2 instance
  key_name = var.ssh_key
  user_data = "sudo systemctl start petclinic.service"
}

# Creating the autoscaling group within eu-west-1a availability zone

resource "aws_autoscaling_group" "jack-asg-group-1a" {
# Defining the availability Zone in which AWS EC2 instance will be launched
  availability_zones        = ["eu-west-1a"]
# Specifying the name of the autoscaling group
  name                      = "jack-petclinic-1a-autoscalegroup"
# Defining the maximum number of AWS EC2 instances while scaling
  max_size                  = 2
# Defining the minimum number of AWS EC2 instances while scaling
  min_size                  = 1
# Grace period is the time after which AWS EC2 instance comes into service before checking health.
  health_check_grace_period = 30
# The Autoscaling will happen based on health of AWS EC2 instance defined in AWS CLoudwatch Alarm 
  health_check_type         = "EC2"
# force_delete deletes the Auto Scaling Group without waiting for all instances in the pool to terminate
  force_delete              = true
# Defining the termination policy where the oldest instance will be replaced first 
  termination_policies      = ["OldestInstance"]
# Scaling group is dependent on autoscaling launch configuration because of AWS EC2 instance configurations
  launch_configuration      = aws_launch_configuration.jack-launch-config.name
}


resource "aws_autoscaling_group" "jack-asg-group-1b" {
# Defining the availability Zone in which AWS EC2 instance will be launched
  availability_zones        = ["eu-west-1b"]
  name                      = "jack-petclinic-1b-autoscalegroup"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 30
  health_check_type         = "EC2"
  force_delete              = true
  termination_policies      = ["OldestInstance"]
  launch_configuration      = aws_launch_configuration.jack-launch-config.name
}

# Creating the autoscaling schedule of the autoscaling group for AZ 1a


  # Off hours of PetCLinic
  resource "aws_autoscaling_schedule" "off-1a" {
      scheduled_action_name  = "off_instance"
      min_size               = 1
      max_size               = 2
      desired_capacity       = 1
      time_zone              = "Europe/London"
      recurrence             = "0 17 * * *"
      autoscaling_group_name = aws_autoscaling_group.jack-asg-group-1a.name
      lifecycle {
        ignore_changes = [start_time]
      }
    }
    
    # On hours of PetClinic
    resource "aws_autoscaling_schedule" "on-1a" {
      scheduled_action_name  = "on_instance"
      min_size               = 2
      max_size               = 3
      desired_capacity       = 2
      time_zone              = "Europe/London"
      recurrence             = "0 9 * * MON-FRI"
      autoscaling_group_name = aws_autoscaling_group.jack-asg-group-1a.name
      lifecycle {
        ignore_changes = [start_time]
      }
    }

# Creating the autoscaling schedule of the autoscaling group for AZ 1b


  # Off hours of PetCLinic
  resource "aws_autoscaling_schedule" "off-1b" {
      scheduled_action_name  = "off_instance"
      min_size               = 1
      max_size               = 2
      desired_capacity       = 1
      time_zone              = "Europe/London"
      recurrence             = "0 18 * * *"
      autoscaling_group_name = aws_autoscaling_group.jack-asg-group-1b.name
      lifecycle {
        ignore_changes = [start_time]
      }
    }
    
    # On hours of PetClinic
    resource "aws_autoscaling_schedule" "on-1b" {
      scheduled_action_name  = "on_instance"
      min_size               = 2
      max_size               = 3
      desired_capacity       = 2
      #start_time             =  "${local.today_date}T8:00:00Z" 
      time_zone              = "Europe/London"
      recurrence             = "0 9 * * MON-FRI"
      autoscaling_group_name = aws_autoscaling_group.jack-asg-group-1b.name
      lifecycle {
        ignore_changes = [start_time]
      }
    }


# Creating the autoscaling policy of the autoscaling group AZ 1a

resource "aws_autoscaling_policy" "jack-petclinic-asg-grouppolicy-1a" {
  name                   = "petclinic-1a-autoscalegroup-policy"
# The number of instances by which to scale.
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
# The amount of time (seconds) after a scaling completes and the next scaling starts.
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.jack-asg-group-1a.name
}

# Creating the autoscaling policy of the autoscaling group AZ 1b

resource "aws_autoscaling_policy" "jack-petclinic-asg-grouppolicy-1b" {
  name                   = "petclinic-1b-autoscalegroup-policy"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.jack-asg-group-1b.name
}


# Creating the AWS CLoudwatch Alarm that will autoscale the AWS EC2 instance based on CPU utilization.

resource "aws_cloudwatch_metric_alarm" "jack-petclinic-web-cpu-alarm-up-1a" {
# defining the name of AWS cloudwatch alarm
  alarm_name = "jack_petclinic_1a_web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
# Defining the metric_name according to which scaling will happen (based on CPU) 
  metric_name = "CPUUtilization"
# The namespace for the alarm's associated metric
  namespace = "AWS/EC2"
# After AWS Cloudwatch Alarm is triggered, it will wait for 60 seconds and then autoscales
  period = "60"
  statistic = "Average"
# CPU Utilization threshold is set to 10 percent
  threshold = "10"
  alarm_actions = [
        "${aws_autoscaling_policy.jack-petclinic-asg-grouppolicy-1a.arn}"
    ]
dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.jack-asg-group-1a.name}"
  }
}


resource "aws_cloudwatch_metric_alarm" "jack-petclinic-web-cpu-alarm-up-1b" {
  alarm_name = "jack_petclinic_1b_web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "10"
  alarm_actions = [
        "${aws_autoscaling_policy.jack-petclinic-asg-grouppolicy-1b.arn}"
    ]
dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.jack-asg-group-1b.name}"
  }
}