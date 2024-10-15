#!/bin/bash
              #Atualiza os pacotes
              sudo apt update && sudo apt upgrade 
              sudo su -
                             
              #Traz os arquivos de configuração do S3
              cd /tmp
              wget https://s3.amazonaws.com/ansible.wordpress/install_docker.sh
              wget https://s3.amazonaws.com/ansible.wordpress/Dockerfile
              wget https://s3.amazonaws.com/ansible.wordpress/index.html

              #Permissiona o arquivo e executa em seguida
              chmod 755 install_docker.sh
              ./install_docker.sh  -y

              #Construção do container
              docker build -t hello-world-nginx .
              docker run -p 8080:80 hello-world-nginx              
