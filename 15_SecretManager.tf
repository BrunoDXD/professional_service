#Criação da minha senha do RDS
resource "random_password" "password" {
  length  = 16
  special = false
}

#Criação do Secret Manager
resource "aws_secretsmanager_secret" "db_password" {
  name = "dev/mysql/password_db"
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.password.result
}

#Traz as informações do Secret Manager
data "aws_secretsmanager_secret" "db_password" {
  name = "dev/mysql/password_db"
  depends_on = [
    aws_secretsmanager_secret.db_password
  ]
}

data "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}



