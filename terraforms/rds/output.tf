output "metadata_db" {
  value = aws_db_instance.metadata_db
}

output "metadata_db_endpoint" {
  value = "${aws_db_instance.metadata_db.endpoint}"
}

output "metadata_db_address" {
  value = "${aws_db_instance.metadata_db.address}"
}

output "metadata_db_postgres_password" {
  value = "${random_string.metadata_db_password.result}"
}
