variable "tag" {
  type = string
}

variable "subnet_id" {
  type = list(string)
}

variable "security_group_efs_airflow" {
  type = string
}
