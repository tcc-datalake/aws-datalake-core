variable "airflow_public_subnet" {
  type = list(string)
}

variable "instance" {
  type = string
}

variable "security_group_redis_id" {
  type = string
}
