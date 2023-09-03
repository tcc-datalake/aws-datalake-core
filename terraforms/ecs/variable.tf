variable "cpu" {
  type = string
}

variable "memory" {
  type = string
}

variable "ecs_role_arn" {
  type = string
}

variable "db_password" {
  type = string
}

variable "metadata_db_address" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_alb_airflow_web_server_id" {
  type = string
}

variable "aws_alb_airflow_flower_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ecs_web_server_id" {
  type = string
}

variable "security_group_ecs_airflow_scheduler_id" {
  type = string
}

variable "security_group_ecs_airflow_worker_id" {
  type = string
}

variable "security_group_ecs_airflow_flower_id" {
  type = string
}

variable "celery_backend_address" {
  type = string
}

variable "alb_airflow_web_server" {
}

variable "alb_airflow_flower" {
}

variable "celery_backend" {
}

variable "metadata_db" {
}

variable "log_group_tasks_arn" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "airflow_repository_url" {
  type = string
}
