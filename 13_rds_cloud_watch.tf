#----------------------------Mètrica de Burst Balance------------------------------------
#Define o nome do SNS
resource "aws_sns_topic" "rds_bb_sns" {
  name = "rds-burst-balance-alerts"
}

#Assinatura SNS
resource "aws_sns_topic_subscription" "email_subscription_bb" {
  topic_arn = aws_sns_topic.rds_bb_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

#Métrica dos Créditos E/S, aciona menos que 20%
resource "aws_cloudwatch_metric_alarm" "rds_bb" {
  alarm_name                = "Burst Balance RDS"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 1
  metric_name               = "BurstBalance"
  namespace                 = "AWS/RDS"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 20
  alarm_description         = "Alarme para monitorar o BurstBalance do RDS"
  
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.web.id
  }

  alarm_actions = [aws_sns_topic.rds_bb_sns.arn]
  ok_actions    = [aws_sns_topic.rds_bb_sns.arn]
}


#----------------------------Mètrica de CPU-------------------------------------
#Define o nome do SNS
resource "aws_sns_topic" "rds_cpu_sns" {
  name = "rds-cpu-utilization-alerts"
}

#Assinatura SNS
resource "aws_sns_topic_subscription" "email_subscription_cpu" {
  topic_arn = aws_sns_topic.rds_cpu_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

#Métrica uso de CPU, aciona mais que 80%
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name                = "Utilização CPU RDS"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "Alarme para monitorar a utilização da CPU do RDS"
  
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.web.id
  }

  alarm_actions = [aws_sns_topic.rds_cpu_sns.arn]
  ok_actions    = [aws_sns_topic.rds_cpu_sns.arn]
}

