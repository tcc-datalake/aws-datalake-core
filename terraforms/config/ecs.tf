# ResourceInitializationError: failed to invoke EFS utils commands to set up EFS volumes: stderr: b'mount.nfs4: mounting fs-06f98f3e7fbc8300c.efs.us-east-1.amazonaws.com:/data/airflow failed, reason given by server: No such file or directory' : unsuccessful EFS utils command execution; code: 32

module "ecs" {
  source                                  = "../ecs"
  cpu                                     = "256"
  memory                                  = "512"
  log_group_name                          = "ecs/fargate"
  aws_region                              = var.region
  ecs_role_arn                            = module.iam.ecs_role_arn
  metadata_db_address                     = module.rds.metadata_db_address
  db_password                             = module.rds.metadata_db_postgres_password
  aws_alb_airflow_web_server_id           = module.alb.aws_alb_airflow_web_server_id
  aws_alb_airflow_flower_id               = module.alb.aws_alb_airflow_flower_id
  subnet_id                               = module.networking.airflow_public_subnet
  security_group_ecs_web_server_id        = module.networking.security_group_ecs_web_server_id
  security_group_ecs_airflow_scheduler_id = module.networking.security_group_ecs_airflow_scheduler_id
  security_group_ecs_airflow_worker_id    = module.networking.security_group_ecs_airflow_worker_id
  security_group_ecs_airflow_flower_id    = module.networking.security_group_ecs_airflow_flower_id
  celery_backend_address                  = module.elasticache.celery_backend_address
  log_group_tasks_arn                     = module.cloudwatch.log_group_tasks_arn
  airflow_repository_url                  = module.ecr.airflow_repository_url
  efs_airflow_id                          = module.efs.efs_airflow_id

  alb_airflow_web_server                  = module.alb.alb_airflow_web_server
  alb_airflow_flower                      = module.alb.alb_airflow_flower
  celery_backend                          = module.elasticache.celery_backend
  metadata_db                             = module.rds.metadata_db
}
