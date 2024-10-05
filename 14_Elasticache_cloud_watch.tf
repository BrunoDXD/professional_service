#----------------------------Métrica de Uso de Memória para Memcached------------------------------------
# Define o nome do SNS
resource "aws_sns_topic" "memcached_memory_usage_sns" {
  name = "memcached-memory-usage-alerts"
}

# Assinatura SNS
resource "aws_sns_topic_subscription" "email_subscription_m" {
  topic_arn = aws_sns_topic.memcached_memory_usage_sns.arn
  protocol  = var.protocolo
  endpoint  = var.email
}

# Métrica de Uso de Memória, aciona mais que 80%
resource "aws_cloudwatch_metric_alarm" "memcached_memory_usage" {
  alarm_name                = "Uso Memória do Memcached"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "BytesUsedForCache"
  namespace                 = "AWS/ElastiCache"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "Alarme para monitorar o uso de memória do Memcached"
  
  dimensions = {
    CacheClusterId = aws_elasticache_cluster.cache_cluster.id
  }

  alarm_actions = [aws_sns_topic.memcached_memory_usage_sns.arn]
  ok_actions    = [aws_sns_topic.memcached_memory_usage_sns.arn]
}