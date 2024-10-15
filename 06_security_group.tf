
#grupo de segurança wordpress
resource "aws_security_group" "sg_wordpress" {
  name        = "sg_wordpress"
  description = "Internet access"
  vpc_id      = aws_vpc.this.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [local.my_ip]
  }

    ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "EFS"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description = "Memcached"
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.common_tags, {
    Name = "sg-Wordpress"
  })
}

#grupo de segurança vpn
resource "aws_security_group" "sg_vpn" {
  name        = "sg_vpn"
  description = "Internet access"
  vpc_id      = aws_vpc.this.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [local.my_ip]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [local.my_ip]
  }

  ingress {
    description = "VPN"
    from_port   = 14253
    to_port     = 14253
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.common_tags, {
    Name = "sg_vpn"
  })
}

#grupo de segurança vpn
resource "aws_security_group" "sg_pvt" {
  name        = "sg_pvt"
  description = "Internet access"
  vpc_id      = aws_vpc.this.id

  ingress {
    description      = "PVT_Instance"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["172.32.16.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.common_tags, {
    Name = "sg_pvt"
  })
}

#cria grupo de segurança do db
resource "aws_security_group" "db" {
  name        = "DB"
  description = "database traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.32.0.0/16"]
  }

  tags = merge(local.common_tags, {
    Name = "RDS"
  })
}  


