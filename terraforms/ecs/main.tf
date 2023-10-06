resource "aws_ecs_cluster" "airflow_cluster" {
  name = "airflow-cluster"
}

# WEB SERVICE
resource "aws_ecs_task_definition" "web_server" {
  family                   = "web-server"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_role_arn
  task_role_arn            = var.ecs_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions = templatefile("${path.module}/task_definitions/task.json", {
    service_name      = "webserver"
    command           = "webserver"
    ecr_image         = "${var.airflow_repository_url}:latest",
    port              = 8080
    stage             = "prod"
    db_credentials    = "root:${var.db_password}@${var.metadata_db_address}:5432/airflow"
    redis_url         = "${var.celery_backend_address}:6379"
    awslogs_group     = "${var.log_group_name}/web-server",
    awslogs_region    = var.aws_region
    path_remote_logs  = "cloudwatch://${var.log_group_tasks_arn}"
    path_airflow_dags = "/usr/local/airflow/dags"
  })
  volume {
    name = "dags"
    efs_volume_configuration {
      file_system_id = var.efs_airflow_id
      root_directory = "/data/airflow"
    }
  }
}

resource "aws_ecs_service" "web_server_service" {
  name                               = "web-server"
  cluster                            = aws_ecs_cluster.airflow_cluster.id
  task_definition                    = aws_ecs_task_definition.web_server.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = 60

  network_configuration {
    security_groups  = [var.security_group_ecs_web_server_id]
    subnets          = var.subnet_id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.aws_alb_airflow_web_server_id
    container_name   = "airflow_webserver"
    container_port   = 8080
  }

  depends_on = [
    var.metadata_db,
    var.alb_airflow_web_server,
    var.celery_backend
  ]
}

# SCHEDULER
resource "aws_ecs_task_definition" "scheduler" {
  family                   = "scheduler"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_role_arn
  task_role_arn            = var.ecs_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions = templatefile("${path.module}/task_definitions/task.json", {
    service_name      = "scheduler"
    command           = "scheduler"
    ecr_image         = "${var.airflow_repository_url}:latest",
    port              = 80
    stage             = "prod"
    db_credentials    = "root:${var.db_password}@${var.metadata_db_address}:5432/airflow"
    redis_url         = "${var.celery_backend_address}:6379"
    awslogs_group     = "${var.log_group_name}/scheduler",
    awslogs_region    = var.aws_region
    path_remote_logs  = "cloudwatch://${var.log_group_tasks_arn}"
    path_airflow_dags = "/usr/local/airflow/dags"
  })
  volume {
    name = "dags"
    efs_volume_configuration {
      file_system_id = var.efs_airflow_id
      root_directory = "/data/airflow"
    }
  }
}

resource "aws_ecs_service" "scheduler_service" {
  name            = "scheduler"
  cluster         = aws_ecs_cluster.airflow_cluster.id
  task_definition = aws_ecs_task_definition.scheduler.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.security_group_ecs_airflow_scheduler_id]
    subnets          = var.subnet_id
    assign_public_ip = true
  }

  depends_on = [
    var.metadata_db,
    var.celery_backend
  ]

}

# WORKERS
resource "aws_ecs_task_definition" "worker" {
  family                   = "worker"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_role_arn
  task_role_arn            = var.ecs_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions = templatefile("${path.module}/task_definitions/task.json", {
    service_name      = "worker"
    command           = "worker"
    ecr_image         = "${var.airflow_repository_url}:latest",
    port              = 8793
    stage             = "prod"
    db_credentials    = "root:${var.db_password}@${var.metadata_db_address}:5432/airflow"
    redis_url         = "${var.celery_backend_address}:6379"
    awslogs_group     = "${var.log_group_name}/worker",
    awslogs_region    = var.aws_region
    path_remote_logs  = "cloudwatch://${var.log_group_tasks_arn}"
    path_airflow_dags = "/usr/local/airflow/dags"
  })
  volume {
    name = "dags"
    efs_volume_configuration {
      file_system_id = var.efs_airflow_id
      root_directory = "/data/airflow"
    }
  }
}

resource "aws_ecs_service" "worker_service" {
  name            = "worker"
  cluster         = aws_ecs_cluster.airflow_cluster.id
  task_definition = aws_ecs_task_definition.worker.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.security_group_ecs_airflow_worker_id]
    subnets          = var.subnet_id
    assign_public_ip = true
  }

  depends_on = [
    var.metadata_db,
    var.celery_backend
  ]
}

# FLOWER
resource "aws_ecs_task_definition" "flower" {
  family                   = "flower"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_role_arn
  task_role_arn            = var.ecs_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions = templatefile("${path.module}/task_definitions/task.json", {
    service_name      = "flower"
    command           = "flower"
    ecr_image         = "${var.airflow_repository_url}:latest",
    port              = 5555
    stage             = "prod"
    db_credentials    = "root:${var.db_password}@${var.metadata_db_address}:5432/airflow"
    redis_url         = "${var.celery_backend_address}:6379"
    awslogs_group     = "${var.log_group_name}/flower",
    awslogs_region    = var.aws_region
    path_remote_logs  = "cloudwatch://${var.log_group_tasks_arn}"
    path_airflow_dags = "/usr/local/airflow/dags"
  })
  volume {
    name = "dags"
    efs_volume_configuration {
      file_system_id = var.efs_airflow_id
      root_directory = "/data/airflow"
    }
  }
}

resource "aws_ecs_service" "flower_service" {
  name            = "flower"
  cluster         = aws_ecs_cluster.airflow_cluster.id
  task_definition = aws_ecs_task_definition.flower.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.security_group_ecs_airflow_flower_id]
    subnets          = var.subnet_id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.aws_alb_airflow_flower_id
    container_name   = "airflow_flower"
    container_port   = 5555
  }

  depends_on = [
    var.metadata_db,
    var.alb_airflow_flower,
    var.celery_backend
  ]
}
