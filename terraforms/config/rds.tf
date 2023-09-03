module "rds" {
  source                     = "../rds"
  instance                   = "db.t4g.micro"
  username                   = "root"
  airflow_public_subnet      = module.networking.airflow_public_subnet
  security_group_postgres_id = module.networking.security_group_postgres_id
  tag                        = "rds-${var.name_tag}"
}
