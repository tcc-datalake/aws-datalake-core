variable "airflow_public_subnet" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "security_group_alb_id" {
  type = string
}