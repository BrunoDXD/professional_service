resource "aws_autoscaling_group" "this" {
  vpc_zone_identifier = [aws_subnet.this["pub_a"].id, aws_subnet.this["pub_b"].id]
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "thisPolicy" {
    name                   = "politica-cpu"
    adjustment_type        = "ChangeInCapacity"
    scaling_adjustment     = 4
    cooldown               = 120
    autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = "Alarme-de-CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_description = "monitoramento da utilização de CPU"
  alarm_actions     = [aws_autoscaling_policy.thisPolicy.arn]
}