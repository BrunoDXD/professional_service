resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content  = tls_private_key.this.private_key_pem
  filename = "${var.caminho}private_key.pem"
}

resource "local_file" "public_key" {
  content  = tls_private_key.this.public_key_openssh
  filename = "${var.caminho}public_key.pem"
}

resource "aws_key_pair" "this" {
  key_name   = "private_key"
  public_key = tls_private_key.this.public_key_openssh
}