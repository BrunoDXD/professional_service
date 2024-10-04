resource "random_password" "password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "dev/mysql/passwordd"
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.password.result
}

data "aws_secretsmanager_secret" "db_password" {
  name = "dev/mysql/passwordd"
  depends_on = [
    aws_secretsmanager_secret.db_password
  ]
}

data "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}



