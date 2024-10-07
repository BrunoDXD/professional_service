#-----------------------Variaveis Principais-------------------
#Caminho onde será criado o par de chaves
variable "caminho" {
  default = "/mnt/c/Users/Bruno/Documents/Minha_pasta/Professional_service"
}

#-----------------------Variaveis da instancia-------------------
#Regiao AWS
variable "region" {
  default =  "us-east-1"
}

#AMI provisionada
variable "ami_aws_instance" {
  default = "ami-07d9b9ddc6cd8dd30"
}

#Tipo da VM
variable "type_aws_instance" {
  default = "t2.micro"
}

#-----------------------Variaveis do Grupo de Segurança EC2-------------------

#Nome do grupo de segurança EC2
variable "name_security_group" {
  default = "allow_ssh"
}

#IP para acessar a maquina via SSH
variable "ip_from_ssh" {
  default = "0.0.0.0/0"
}

#----------------------variaveis do RDS------------------------

#Nome do database
variable "db_name" {
  default = "mydb"
}

#versão do database
variable "db_version" {
  default = "5.7"
}

#classe da instancia do database
variable "db_instance_class" {
  default = "db.m5.large"
}

#--------------------Variaveis da VPC------------------------
# CIDR VPC
variable "vpc_cidr_block" {
  default = "172.32.0.0/16"
}

# SUBNET PUBLICA (NAT GATEWAY PROVISIONADO NESTA SUBNET)
variable "subnet_public_1_cidr" {
  default = "172.32.0.0/24"
}

# SUBNET PUBLICA
variable "subnet_public_2_cidr" {
  default = "172.32.16.0/24"
}

# SUBNET PRIVADA
variable "subnet_private_1_cidr" {
  default = "172.32.32.0/24"
}

# SUBNET PRIVADA
variable "subnet_private_2_cidr" {
  default = "172.32.48.0/24"
}

#--------------------Variaveis do Cloud Watch------------------------
variable "protocolo" {
  default = "email"
}

variable "email" {
  default = "bruno.silva@elven.works"
}