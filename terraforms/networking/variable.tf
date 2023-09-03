variable "vpc_cidr" {
  type        = string
  description = "cidr block of vpc"
}

variable "airbyte_subnets_cidr" {
  type        = string
  description = "cidr block of public subnets"
}

variable "airflow_subnets_cidr" {
  type        = list(string)
  description = "cidr block of public subnets"
}

variable "region" {
  type        = string
  description = "region"
}

variable "availability_zones" {
  type        = list(string)
  description = "availability zones"
}

variable "tag" {
  type        = string
  description = "module tag"
}
