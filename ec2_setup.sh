#!/bin/bash
              #Atualiza os pacotes
              sudo apt update && sudo apt upgrade
              
              #Traz os arquivos de configuração do S3
              cd /tmp
              wget https://s3.amazonaws.com/ansible.wordpress/Ansible.zip 

              #Descompacta o arquivo ansible
              sudo apt install unzip
              unzip Ansible.zip
              cd Ansible              

              #Permissiona os arquivos e executa em seguida
              wget https://s3.amazonaws.com/ansible.wordpress/execute_ansible.sh
              chmod 755 execute_ansible.sh
              ./execute_ansible.sh 
