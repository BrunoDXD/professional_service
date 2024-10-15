#!/bin/bash
              #Atualiza os pacotes
              sudo apt update && sudo apt upgrade
              sudo su -
              
              #Traz os arquivos de configuração do S3
              cd /tmp
              wget https://s3.amazonaws.com/ansible.wordpress/install_pritul.sh

              #Permissiona os arquivos e executa em seguida
              chmod 755 install_pritul.sh
              ./install_pritul.sh -y