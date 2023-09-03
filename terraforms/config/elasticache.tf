module "elasticache" {
  source                  = "../elasticache"
  instance                = "cache.t4g.micro"
  airflow_public_subnet   = module.networking.airflow_public_subnet
  security_group_redis_id = module.networking.security_group_redis_id
}