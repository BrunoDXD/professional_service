#Configurações do template da instancia wordpress
resource "aws_launch_template" "this" {
    name_prefix                 = "this"
    image_id                    = var.ami_aws_instance
    instance_type               = var.type_aws_instance
    key_name                    = var.key_aws_instance

  user_data = base64encode(
  templatefile("userdata/ec2_setup.sh", 
  {
    wp_db_name        = aws_db_instance.web.name
    wp_username       = aws_db_instance.web.username
    wp_user_password  = aws_db_instance.web.password
    wp_db_host        = aws_db_instance.web.address 
    efs_id            = "${aws_efs_file_system.efs.id}"
  }))
    
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.allow_ssh.id]
  }

  monitoring { 
    enabled = true
  }

    tag_specifications {
      resource_type = "instance"
      tags = merge(local.common_tags, {
        Name = "Wordpress"
      })
    }
  
}

#configuração da Instancia privada 
resource "aws_instance" "private_instance" {
  ami                    = var.ami_aws_instance
  instance_type          = var.type_aws_instance
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = var.key_aws_instance
  user_data = base64encode(
  templatefile("userdata/HelloWorld.sh",{}))
  monitoring             = true
  subnet_id              = aws_subnet.this["pvt_b"].id
  associate_public_ip_address = true
  

  tags = {
    Name = "Private-instance"
  }
}

#configuração do server VPN
resource "aws_instance" "vpn-server" {
  ami                    = var.ami_aws_instance
  instance_type          = var.type_aws_instance
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = var.key_aws_instance
  user_data = base64encode(
  templatefile("userdata/vpn-server.sh",{}))
  monitoring             = true
  subnet_id              = aws_subnet.this["pub_b"].id
  associate_public_ip_address = true
  

  tags = {
    Name = "VPN-Server"
  }
}

