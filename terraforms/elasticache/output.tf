output "celery_backend" {
  value = aws_elasticache_cluster.celery_backend

}

output "celery_backend_address" {
  value = "${aws_elasticache_cluster.celery_backend.cache_nodes.0.address}"
}