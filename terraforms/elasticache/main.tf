resource "aws_elasticache_subnet_group" "airflow_redis_subnet_group" {
  name       = "elasticache-subnet"
  subnet_ids = var.airflow_public_subnet
}

resource "aws_elasticache_cluster" "celery_backend" {
  cluster_id         = "elasticache-celery"
  engine             = "redis"
  engine_version     = "5.0.6"
  node_type          = var.instance
  num_cache_nodes    = 1
  port               = "6379"
  subnet_group_name  = aws_elasticache_subnet_group.airflow_redis_subnet_group.id
  security_group_ids = [var.security_group_redis_id]
}
