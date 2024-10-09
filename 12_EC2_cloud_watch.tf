#----------------------------Métrica de CPU para EC2 Privada-------------------------------------
# Define o nome do SNS
resource "aws_sns_topic" "ec2_cpu_sns" {
  name = "ec2-cpu-utilization-alerts"
}

# Assinatura SNS
resource "aws_sns_topic_subscription" "email_subscription_CPU" {
  topic_arn = aws_sns_topic.ec2_cpu_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

# Métrica uso de CPU, aciona mais que 80%
resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  alarm_name                = "CPU EC2 Privada"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "Alarme para monitorar a utilização da CPU da instância EC2"
  
  dimensions = {
    InstanceId = aws_instance.private_instance.id
  }

  alarm_actions = [aws_sns_topic.ec2_cpu_sns.arn]
  ok_actions    = [aws_sns_topic.ec2_cpu_sns.arn]
}

#----------------------------Métrica de Disponibilidade para as EC2 Privada------------------------------------
# Define o nome do SNS
resource "aws_sns_topic" "ec2_availability_sns_pvt" {
  name = "ec2-availability-alerts"
}

# Assinatura SNS
resource "aws_sns_topic_subscription" "email_subscription_pvt" {
  topic_arn = aws_sns_topic.ec2_availability_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

# Métrica de Disponibilidade da EC2, aciona quando a instância não está disponível
resource "aws_cloudwatch_metric_alarm" "ec2_availability_pvt" {
  alarm_name                = "Disponibilidade EC2 Privada"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Minimum"
  threshold                 = 0
  alarm_description         = "Alarme para monitorar a disponibilidade da instância EC2"
  
  dimensions = {
    InstanceId = aws_instance.private_instance.id
  }

  alarm_actions = [aws_sns_topic.ec2_availability_sns.arn]
  ok_actions    = [aws_sns_topic.ec2_availability_sns.arn]
}

#----------------------------Métrica de Disponibilidade para as EC2 vpn------------------------------------
# Define o nome do SNS
resource "aws_sns_topic" "ec2_availability_sns" {
  name = "ec2-availability-alerts"
}

# Assinatura SNS
resource "aws_sns_topic_subscription" "email_subscription_d" {
  topic_arn = aws_sns_topic.ec2_availability_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

# Métrica de Disponibilidade da EC2, aciona quando a instância não está disponível
resource "aws_cloudwatch_metric_alarm" "ec2_availability" {
  alarm_name                = "Disponibilidade EC2 VPN"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Minimum"
  threshold                 = 0
  alarm_description         = "Alarme para monitorar a disponibilidade da instância EC2"
  
  dimensions = {
    InstanceId = aws_instance.vpn_server.id
  }

  alarm_actions = [aws_sns_topic.ec2_availability_sns.arn]
  ok_actions    = [aws_sns_topic.ec2_availability_sns.arn]
}

#----------------------------Métrica de NetworkIn para EC2 Wordpress------------------------------------
# Define o nome do SNS
resource "aws_sns_topic" "ec2_networkin_sns" {
  name = "ec2-networkin-alerts"
}

# Assinatura SNS
resource "aws_sns_topic_subscription" "email_subscription_ntw" {
  topic_arn = aws_sns_topic.ec2_networkin_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

# Métrica uso de NetworkIn, aciona mais que 500MB
resource "aws_cloudwatch_metric_alarm" "ec2_networkin" {
  alarm_name                = "Tráfego de entrada wordpress"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "NetworkIn"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 524288000  # 500 MB
  alarm_description         = "Alarme para monitorar o tráfego de entrada da instância EC2"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_actions = [aws_sns_topic.ec2_networkin_sns.arn]
  ok_actions    = [aws_sns_topic.ec2_networkin_sns.arn]
}