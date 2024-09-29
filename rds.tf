#Criação do RDS 
 resource "aws_db_instance" "web" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.m5.large"
  db_name              = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  availability_zone    = "${var.region}a"
  skip_final_snapshot  = true

  db_subnet_group_name   = aws_db_subnet_group.default.id
  vpc_security_group_ids = [aws_security_group.db.id]
}

#declarando a subnet do rds
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.this["pvt_a"].id, aws_subnet.this["pvt_b"].id]

  tags = merge(local.common_tags, {
    Name = "DB Subnet Group"
  })
}  