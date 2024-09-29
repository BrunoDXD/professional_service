# Criação da VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = merge(local.common_tags, {
    Name = "main-VPC"
  })
}

#Array e criação das Subnets
resource "aws_subnet" "this" {
  for_each = {
    "pub_a" : ["${var.subnet_public_1_cidr}", "${var.region}a", "Publica A"]
    "pub_b" : ["${var.subnet_public_2_cidr}", "${var.region}b", "Publica B"]
    "pvt_a" : ["${var.subnet_private_1_cidr}", "${var.region}a", "Privada A"]
    "pvt_b" : ["${var.subnet_private_2_cidr}", "${var.region}b", "Privada B"]
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value[0]
  availability_zone = each.value[1]

  tags = merge(local.common_tags, {
    Name = each.value[2]
  })
}

#Associação das Rotas 
resource "aws_route_table_association" "this" {
  for_each = local.subnet_ids

  subnet_id      = each.value
  route_table_id = substr(each.key, 0, 3) == "Pub" ? aws_route_table.public.id : aws_route_table.private.id
}

#internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "Gateway-Wordpress"
  })
}


# Criação da tabela de Rotas publicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.common_tags, {
    Name = "Route-pub"
  })
}

# Criação do Nat Gateway para subnets privadas
resource "aws_eip" "this" {
  vpc = true

  tags = merge(local.common_tags, {
    Name = "eip-ngw"
  })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.this["pub_a"].id
  depends_on    = [aws_internet_gateway.this]

  tags = merge(local.common_tags, {
    Name = "Wordpress-Ngw"
  })
}

# Criação da Tabela de rotas das subnets privadas com NTG
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(local.common_tags, {
    Name = "Route-pvt"
  })
}








