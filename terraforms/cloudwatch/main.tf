resource "aws_cloudwatch_log_group" "log_group_web_server" {
  name = "ecs/fargate/web-server"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "log_group_scheduler" {
  name = "ecs/fargate/scheduler"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "log_group_worker" {
  name = "ecs/fargate/worker"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "log_group_flower" {
  name = "ecs/fargate/flower"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "log_group_tasks" {
  name = "tasks"
  retention_in_days = 1
}