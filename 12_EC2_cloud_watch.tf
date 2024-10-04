#----------------------------Métrica de CPU para EC2------------------------------------
# Define o nome do SNS
resource "aws_sns_topic" "ec2_cpu_sns" {
  name = "ec2-cpu-utilization-alerts"
}

# Assinatura SNS
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.ec2_cpu_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

# Métrica uso de CPU, aciona mais que 80%
resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  alarm_name                = "EC2_CPUUtilization"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "Alarme para monitorar a utilização da CPU da instância EC2"
  
  dimensions = {
    InstanceId = aws_instance.web.id
  }

  alarm_actions = [aws_sns_topic.ec2_cpu_sns.arn]
  ok_actions    = [aws_sns_topic.ec2_cpu_sns.arn]
}

