output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "airflow_public_subnet" {
  value = aws_subnet.airflow_public_subnet[*].id
}

output "security_group_airbyte_id" {
  value = aws_security_group.airbyte.id
}

output "security_group_redis_id" {
  value = aws_security_group.redis.id
}

output "security_group_postgres_id" {
  value = aws_security_group.postgres.id
}

output "security_group_alb_id" {
  value = aws_security_group.alb.id
}

output "security_group_ecs_web_server_id" {
  value = aws_security_group.web_server.id
}

output "security_group_ecs_airflow_worker_id" {
  value = aws_security_group.airflow_worker.id
}

output "security_group_ecs_airflow_scheduler_id" {
  value = aws_security_group.airflow_scheduler.id
}

output "security_group_ecs_airflow_flower_id" {
  value = aws_security_group.airflow_flower.id
}