variable "aws_glue_role_arn" {
  type = string
}

variable "name_tag" {
  type = string
}

variable "jobs" {
  type = list(string)
}