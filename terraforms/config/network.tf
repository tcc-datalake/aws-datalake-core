module "networking" {
  source               = "../networking"
  vpc_cidr             = "10.0.0.0/16"
  airbyte_subnets_cidr = "10.0.1.0/24"
  airflow_subnets_cidr = ["10.0.2.0/24", "10.0.3.0/24"]
  region               = var.region
  availability_zones   = var.availability_zones
  tag                  = "networking-${var.name_tag}"
}