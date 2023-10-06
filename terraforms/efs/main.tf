resource "aws_efs_file_system" "efs" {
  creation_token = "airflow-ecs"

  tags = {
    Name = var.tag
  }
}

resource "aws_efs_mount_target" "efs-mount-a" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.subnet_id[0]
  security_groups = [var.security_group_efs_airflow]
}

resource "aws_efs_mount_target" "efs-mount-b" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.subnet_id[1]
  security_groups = [var.security_group_efs_airflow]
}

resource "aws_efs_access_point" "example_access_point" {
  file_system_id = aws_efs_file_system.efs.id
  posix_user {
    uid = "1000"
    gid = "1000"
  }
  root_directory {
    path = "/data/airflow"
    creation_info {
      owner_gid   = "1000"
      owner_uid   = "1000"
      permissions = "777"
    }
  }
}