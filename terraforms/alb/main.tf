resource "aws_alb" "airflow" {
  name            = "alb"
  subnets         = var.airflow_public_subnet
  security_groups = [var.security_group_alb_id]
}

resource "aws_alb_target_group" "airflow_web_server" {
  name        = "web-server"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval            = 60
    port                = 8080
    protocol            = "HTTP"
    path                = "/health"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 3
  }
}

resource "aws_alb_listener" "airflow_web_server" {
  load_balancer_arn = aws_alb.airflow.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.airflow_web_server.id
    type             = "forward"
  }
}

resource "aws_alb_target_group" "airflow_flower" {
  name        = "flower"
  port        = 5555
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval            = 60
    port                = 5555
    protocol            = "HTTP"
    path                = "/health"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 3
  }
}

resource "aws_alb_listener" "airflow_flower" {
  load_balancer_arn = aws_alb.airflow.id
  port              = "5555"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.airflow_flower.id
    type             = "forward"
  }
}
