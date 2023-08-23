variable "security_group_id" {
  type        = string
  description = "security group id"
}

variable "subnet_id" {
  type        = string
  description = "subnet id"
}

variable "instance_type" {
  type        = string
  description = "instance type"
}

variable "storage_size" {
  type        = number
  description = "storage size"
}

variable "tag" {
  type        = string
  description = "tag"
}

variable "application_name" {
  type        = string
  description = "application name"
}

variable "application_template" {
  type        = string
  description = "application name"
}