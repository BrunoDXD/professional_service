#arquivo Locals
locals {
  subnet_ids = { for k, v in aws_subnet.this : v.tags.Name => v.id }
  my_ip = "${chomp(data.http.my_ip.response_body)}/32"

  common_tags = {
    Project   = "Projeto Professional Service Elven Works"
    CreatedAt = "2024-10-01"
    ManagedBy = "Terraform"
    Owner     = "Bruno Silva"
    Service   = "Professional Service"
  } 
}

data "http" "my_ip" {
  url = "https://api.ipify.org?format=text"
}
