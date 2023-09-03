output "alb_airflow_web_server" {
  value = aws_alb_listener.airflow_web_server
}

output "aws_alb_airflow_web_server_id" {
  value = aws_alb_target_group.airflow_web_server.id
}

output "alb_airflow_flower" {
  value = aws_alb_listener.airflow_flower
}

output "aws_alb_airflow_flower_id" {
  value = aws_alb_target_group.airflow_flower.id
}