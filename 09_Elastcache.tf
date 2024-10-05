#Relaciona o Elasticache com a subnet privada a
resource "aws_elasticache_subnet_group" "this" {
  name       = "subnetMemcached"
  subnet_ids = [aws_subnet.this["pvt_a"].id]
}

#Criação do cluster elastcache
resource "aws_elasticache_cluster" "cache_cluster" {
  cluster_id           = "cluster-memcached"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.6"
  engine_version       = "1.6.22"
  az_mode              = "single-az"
  port                 = 11211
  network_type         = "ipv4"
  security_group_ids   = [aws_security_group.allow_ssh.id]
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  apply_immediately    = true

  tags = {
    "Name" = "Cluster_elasticache"
  }
}

