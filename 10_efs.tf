resource "aws_efs_file_system" "efs" {
    creation_token = "EFS for Backup"
    throughput_mode = "bursting"
    encrypted = "true"
  tags = {
    Name = "EC2-EFS-FS"
  }
}

resource "aws_efs_mount_target" "efs" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.this["pvt_b"].id
 security_groups = [aws_security_group.allow_ssh.id]

  depends_on = [
    aws_efs_file_system.efs,
 ]
  
}


