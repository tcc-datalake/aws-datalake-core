resource "random_string" "metadata_db_password" {
  length = 32
  upper = true
  numeric = true
  special = false
}

resource "aws_db_subnet_group" "airflow_subnet_group" {
  name       = "postgres_subnet"
  subnet_ids = var.airflow_public_subnet

  tags = {
    Name = var.tag
  }
}

resource "aws_db_instance" "metadata_db" {
  identifier = "airflow"
  db_name    = "airflow"

  instance_class         = var.instance
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "14.3"
  skip_final_snapshot    = true
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.airflow_subnet_group.id
  vpc_security_group_ids = [var.security_group_postgres_id]
  username               = var.username
  password               = random_string.metadata_db_password.result

  tags = {
    Name = var.tag
  }
}
