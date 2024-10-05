#!/bin/bash
            #Atualiza os pacotes
              sudo apt update && sudo apt upgrade 
              sudo apt-get install -y nfs-common
              
            #ponto de montagem efs compartilhado em todas as maquinas
              mkdir /efs
              efs_dns_name="${efs_dns_name}"
              mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $efs_dns_name:/ /efs

            #Subindo Wordpress com Ansible  
              cd /tmp
              wget https://s3.amazonaws.com/ansible.wordpress/Ansible.zip
              sudo apt install unzip
              unzip Ansible.zip
              cd Ansible
              sudo apt install curl ansible -y
              sudo add-apt-repository ppa:ondrej/php -y
              sudo apt-get update
              sudo ansible-playbook wordpress.yml --extra-vars "wp_db_name=${wp_db_name} wp_db_username=${wp_username} wp_db_password=${wp_user_password} wp_db_host=${wp_db_host} session_save_path=''"

            #ponto de montagem efs compartilhado no autoscaling
              mkdir -p /var/www/html/wp-content/uploads
              mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $efs_dns_name:/ /var/www/html/wp-content/uploads
              echo "$efs_dns_name:/ /var/www/html/wp-content/uploads nfs4 defaults,_netdev 0 0" >> /etc/fstab

            # Configurar o Memcached para usar o cluster
              aws_elasticache="${aws_elasticache}"
              apt-get install -y php7.4-memcached memcached
              echo "session.save_handler = memcached" >> /etc/php/7.4/fpm/php.ini
              echo "session.save_path = '${aws_elasticache}'" >> /etc/php/7.4/fpm/php.ini
              systemctl restart php7.4-fpm
              
            # Instalar WordPress CLI para facilitar a configuração
              curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
              chmod +x wp-cli.phar
              mv wp-cli.phar /usr/local/bin/wp
              cd /var/www/html

            # Configurar o WordPress para usar Memcached
              wp config set WP_CACHE true --path="/var/www/html/wordpress" --allow-root
              wp config set memcached_servers "array( 'default' => array( '${aws_elasticache}' ) );" --path="/var/www/html/wordpress" --allow-root
              systemctl restart php7.4-fpm
