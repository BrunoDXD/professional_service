#!/bin/bash
              #Atualiza os pacotes
              sudo apt update && sudo apt upgrade
              sudo su -
              
              #comando de configuração do EFS
              sudo apt-get install -y nfs-common 
              mkdir /efs
              efs_dns_name="${efs_dns_name}"
              mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $efs_dns_name:/ /efs
              
              #Traz os arquivos de configuração do S3
              cd /tmp
              wget https://s3.amazonaws.com/ansible.wordpress/install_pritul.sh

              #Permissiona os arquivos e executa em seguida
              chmod 755 install_pritul.sh
              ./install_pritul.sh -y