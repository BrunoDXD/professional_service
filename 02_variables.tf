#-----------------------Variaveis Principais-------------------

variable "caminho" {
  default = "caminho da pasta do clone/professional_service/"
  description = "Caminho onde será criado o par de chaves"
}

variable "email" {
  default = "seuEmail@exemplo.com"
  description = "Email para receber alertas"
}

#-----------------------Variaveis da instancia-------------------

variable "region" {
  default =  "us-east-1"
  description = "Regiao AWS"
}

variable "ami_aws_instance" {
  default = "ami-07d9b9ddc6cd8dd30"
  description = "AMI provisionada"
}

variable "type_aws_instance" {
  default = "t2.micro"
  description = "Tipo da VM"
}

#----------------------variaveis do RDS------------------------

variable "db_name" {
  default = "mydb"
  description = "Nome do database"
}

variable "db_version" {
  default = "5.7"
  description = "versão do database"
}

variable "db_instance_class" {
  default = "db.m5.large"
  description = "classe da instancia do database"
}

#--------------------Variaveis da VPC------------------------

variable "vpc_cidr_block" {
  default = "172.32.0.0/16"
  description = "CIDR VPC"
}

variable "subnet_public_1_cidr" {
  default = "172.32.0.0/24"
  description = "SUBNET PUBLICA A(NAT GATEWAY PROVISIONADO NESTA SUBNET)"
}

variable "subnet_public_2_cidr" {
  default = "172.32.16.0/24"
  description = "SUBNET PUBLICA B"
}

variable "subnet_private_1_cidr" {
  default = "172.32.32.0/24"
  description = "SUBNET PRIVADA A"
}

variable "subnet_private_2_cidr" {
  default = "172.32.48.0/24"
  description = "SUBNET PRIVADA B"
}

#--------------------Variaveis do Cloud Watch------------------------
variable "protocolo" {
  default = "email"
  description = "Protocolo que enviará os alertas"
}

