# README

<h1> Professional Service - Elven Works</h1>

## Sobre

<p>Este projeto foi desenvolvido perante um teste de conhecimento sobre SRE proposto pela empresa Elven Works, privisionando recursos da cloud da AWS com alta disponibilidade e segurança.</p>
<p>Seu objetivo é implementar uma aplicação WordPress em alta disponibilidade na AWS. Utiliza Auto Scaling para escalabilidade automática, EFS para armazenamento compartilhado de mídia, RDS para um banco de dados MySQL gerenciado e Load Balancer para distribuir o tráfego entre as instâncias EC2. Além disso, inclui uma instância EC2 privada rodando um container Docker com uma aplicação “Hello World” e um servidor VPN Pritunl para acesso seguro à instância privada.</p>
<p>Alguns métodos utilizados no código incluem a criação do Par de Chaves e utilização na criação da Instância, criação de uma senha aleatória para o banco de dados (que é armazenado no Secret Manager da AWS), intalação do Wordpress de forma automatizada utilizando Ansible, provisionamento de alarmes do cloudWatch monitorando métricas importantes (alarmando no e-mail caso necessário) e o provisionamento do Recurso Elasticache da AWS (para cachear queries ao banco de dados e otimizar as consultas do wordpress).</p>

### Tabela de Conteúdos

* [Sobre](#sobre)
* [Tabela de conteúdos](#tabela-de-conteúdos)
* [Tecnologias](#tecnologias)
* [Pré Requisitos](#pré-requisitos)
* [Instalação](#instalação)
  * [Preparação](#preparação)
  * [Execução](#execução)
* [Demonstração](#demonstração)
* [Configuração da VPN](#configuração-da-vpn)
* [Nota Importante](#nota-importante)
* [Contato](#contato)


## Tecnologias

- [Terraform](https://www.terraform.io/)
- [AWS](https://aws.amazon.com/pt/?nc2=h_lg)
- [Pritunl](https://pritunl.com/)
- [Ansible](https://docs.ansible.com/ansible/latest/index.html)
- [Docker](https://www.docker.com/)

## Pré Requisitos

- Conta válida na AWS cum um usuário IAM configurado.
- Terraform instalado utilizando tfenv 1.1.7
- Terminal Linux

## Instalação

### Preparação

Primeiro vamos instalar o Terraform com o tfenv para execução do código e o aws-cli para configuirarmos o profile da AWS. Você pode instalar através da documentação oficial: [Terraform](https://developer.hashicorp.com/terraform/install), [TFENV](https://github.com/tfutils/tfenv), [AWS-cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions).
Ou execute os seguintes comandos para executar um arquivo de instalação para o terraform com o tfenv(Criado por mim) e o aws-cli.

```bash
# Traga o arquivo do repositório S3
$ wget https://s3.amazonaws.com/ansible.wordpress/install_terraform.sh

# Execute o arquivo de instalação
$ ./install_terraform.sh
```

Conteúdo do arquivo:
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.zprofile
echo 'export PATH=$PATH:$HOME/.tfenv/bin' >> ~/.bashrc
ln -s ~/.tfenv/bin/* /usr/local/bin
mkdir -p ~/.local/bin/
. ~/.profile
ln -s ~/.tfenv/bin/* ~/.local/bin
which tfenv
tfenv install 1.1.7
tfenv use 1.1.7
```

Instalando o AWS-cli:
```bash
#Instalação do aws-cli 
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip
$ sudo ./aws/install

#Execute o comando e adicione sua Acess Key ID, Secret Key do seu usuário AWS, região default e o formato de saída padrão.
$ aws configure
```

### Execução

Clone o repositório
```bash
#clone do repositório
$ git clone https://github.com/BrunoDXD/professional_service.git


#Acesse a pasta dos arquivos
$ cd professional_service
```
<br>

No arquivo "02_variables.tf", altere a variável caminho para a pasta do seu código. 
Outra alteração que deve ser feita é a variável email, para receber os alertas do cloudWatch
<br>

Inicialize o backend do terraform
```bash
$ terraform init
```
<br>

<h1 align="center">
  <img alt="Readme" title="Readme" src="./img/init.png">
</h1>
<br>

Execute o plan do terraform
```bash
$ terraform plan
```
<br>

<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/Animação.gif">
  <p>Aqui são listados todos os recursos que serão adicionados</p>
</h4>
<br>

Aplique os recursos
```bash
$ terraform apply
```
<br>

Em seguida digite Yes para prosseguir
<h4>
  <img alt="Readme" title="Readme" src="./img/confirma.png">
</h4>
<br>

Mensagem de sucesso:
<h4>
  <img alt="Readme" title="Readme" src="./img/apply.png">
</h4>

## Demonstração

Acessando o IP da maquina do wordpress, podemos ver sua página de primeiro acesso
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/Demonstrativo_Wordpress.gif">
</h4>
<br>

Podemos ver o mesmo ocorrer com a instancia da VPN (Não esqueça de colocar https no link)
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/Demonstrativo_vpn.gif">
</h4>

## Configuração da VPN

Pegue o código no console da aws para se conetar a Instância da VPN
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/passo_vpn1.gif">
</h4>
<br>

Acesse o caminho que foi colocado na variável "caminho" do arquivo 02_variable.tf e execute o comando para dar permissão de acesso a sua chave.
```bash
chmod 400 private_key.pem
``` 
<br>

Cole o código para se conectar via SSH em sua instância VPN ou ajuste o código seguinte (Nome da chave privada.pem, ip_separado_por_traço):
```bash
ssh -i "Nome da chave privada.pem" ubuntu@ec2-ip_separado_por_traço.compute-1.amazonaws.com
```
<br>

Entre como usuário root e execute o seguinte comando para pegar a chave de acesso da VPN
```bash
sudo su -
sudo pritunl setup-key
```
<br>
Acesse a pagina de login da VPN com o ip do servidor
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/Demonstrativo_vpn.gif">
</h4>

<br>
Copie a chave e cole na tela de login
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/passo_vpn2.gif">
</h4>

<br>
execute o comando para obter o usuário e senha default

```bash
 sudo pritunl default-password
```
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/passo_vpn3.gif">
</h4>

<br>
Crie um usuário e senha (Não se esqueça de guardar as credenciais em segurança)
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/passo_vpn4.png">
</h4>

<br>
Crie um servidor e atribua a porta 14253 (Porta na qual habilitamos no Security Group através do código)
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/passo_vpn5.gif">
</h4>

<br>
Adicione uma organização e um usuário (adicione um PIN para acesso de sua preferencia(Opcional))
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/passo_vpn6.gif">
</h4>

<br>
Vincule a Org com o server e de um attach
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/passo_vpn7.gif">
</h4>

<br>
De um start no Server
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/passo_vpn9.png">
</h4>

<br>
Copie o link de configuração do usuário e importe no app pritunl
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/passo_vpn11.gif">
</h4>

<br>
Ao conectarmos na VPN, podemos ver o sucesso de nossa configuração quando acessamos a instância privada através da web 
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/passo_vpn12.gif">
</h4>

## Nota Importante

Utilizamos o recurso NAT Gateway e Ip elástico da AWS para podermos conectar a instância privada na internet e instalar os pacotes necessários para a instalação do efs e do container Docker, mas é um recurso caro. 
Recomendo desabilitá-lo no console da AWS após provar a funcionalidade da aplicação. Caso tenha dúvidas de onde acessar este recurso, assista o GIF a seguir:
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/natgt.gif">
</h4>
<br>

Espere um ou dois minutos até que o nat Gateway seja deletado e libere o IP elástico.
<h4 align="center">
  <img alt="Readme" title="Readme" src="./img/ipelastico.gif">
</h4>
<br>

## Contato

Para feedback ou perguntas, entre em contato através de brunodxd09@gmail.com.

## Notas Finais

Este projeto foi desenvolvido como parte de um teste aplicado pela Elven Works. Foi uma excelente oportunidade para demonstrar minhas habilidades e aprender mais sobre o mundo SRE. 
Agradeço a expêriencia e a confiança!
<br>
#sre #aws #terraform #ansible #pritunl #docker