locals {
  subnet_ids = { for k, v in aws_subnet.this : v.tags.Name => v.id }

  common_tags = {
    Project   = "Projeto Final Bootcamp Elven Works"
    CreatedAt = "2024-04-09"
    ManagedBy = "Terraform"
    Owner     = "Bruno Silva"
    Service   = "Wordpress Turbinado"
  } 
}