module "alb" {
  source                = "../alb"
  airflow_public_subnet = module.networking.airflow_public_subnet
  vpc_id                = module.networking.vpc_id
  security_group_alb_id = module.networking.security_group_alb_id
}
