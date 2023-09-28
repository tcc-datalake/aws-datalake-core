variable "database_name" {
  type = string
}

variable "database_s3_path" {
  type = string
}

variable "table_level_in_path" {
  type = number
}

variable "name_tag" {
  type = string
}

variable "aws_glue_role_arn" {
  type = string
}