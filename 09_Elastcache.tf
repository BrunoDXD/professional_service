#Relaciona o Elasticache com a subnet privada b
resource "aws_elasticache_subnet_group" "this" {
  name       = "subnetMemcached"
  subnet_ids = [aws_subnet.this["pvt_a"].id]
}

#Criação do grupo de segurança
resource "aws_security_group" "custom_sg" {
  name        = "Security_group_elasticache"
  description = "manage traffic"
  vpc_id      = aws_vpc.this.id
  
  ingress{
    description       = "tcp elasticache"
    from_port         = 11211
    to_port           = 11211
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
   }

  egress{
    description       = "allow traffic to reach outside the vpc"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
   }

   tags = {
    Name = "Grupo_Memcached"
  }
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
  security_group_ids   = [aws_security_group.custom_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  apply_immediately    = true

  tags = {
    "Name" = "Cluster_elasticache"
  }
}

