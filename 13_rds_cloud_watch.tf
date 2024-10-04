#----------------------------Mètrica de Burst Balance------------------------------------
#Define o nome do SNS
resource "aws_sns_topic" "rds_bb_sns" {
  name = "rds-burst-balance-alerts"
}

#Assinatura SNS
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.rds_bb_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

#Métrica dos Créditos E/S, aciona menos que 20%
resource "aws_cloudwatch_metric_alarm" "rds_bb" {
  alarm_name                = "BurstBalance"
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


#----------------------------Mètrica de CPU------------------------------------
#Define o nome do SNS
resource "aws_sns_topic" "rds_cpu_sns" {
  name = "rds-cpu-utilization-alerts"
}

#Assinatura SNS
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.rds_cpu_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

#Métrica uso de CPU, aciona mais que 80%
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name                = "CPUUtilization"
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

#----------------------------Métrica de FreeStorageSpace------------------------------------
# Define o nome do SNS
resource "aws_sns_topic" "rds_free_storage_space_sns" {
  name = "rds-free-storage-space-alerts"
}

# Assinatura SNS
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.rds_free_storage_space_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

# Métrica FreeStorageSpace, aciona menos que 10 GB
resource "aws_cloudwatch_metric_alarm" "rds_free_storage_space" {
  alarm_name                = "FreeStorageSpace"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 2
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/RDS"
  period                    = 120
  statistic                 = "Minimum"
  threshold                 = 10737418240  # 10 GB em bytes
  alarm_description         = "Alarme para monitorar o espaço de armazenamento livre do RDS"
  
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.web.id
  }

  alarm_actions = [aws_sns_topic.rds_free_storage_space_sns.arn]
  ok_actions    = [aws_sns_topic.rds_free_storage_space_sns.arn]
}
