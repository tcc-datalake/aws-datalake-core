output "glue_role_arn" {
  value = aws_iam_role.glue_role.arn
}

output "ecs_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}
