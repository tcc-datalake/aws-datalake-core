variable "instance" {
  type = string
}

variable "username" {
  type = string
}

variable "airflow_public_subnet" {
  type = list(string)
}

variable "security_group_postgres_id" {
  type = string
}

variable "tag" {
  type = string
}
