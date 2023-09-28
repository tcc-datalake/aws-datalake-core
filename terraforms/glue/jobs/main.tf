resource "aws_glue_job" "jobs" {
  for_each = { for job in var.jobs : job => regex(".*\\/jobs\\/(.*)\\.py", job)[0] }

  name         = each.value
  role_arn     = var.aws_glue_role_arn
  glue_version = "4.0"
  max_retries  = 1
  timeout      = 3000

  command {
    script_location = "s3://${var.name_tag}-glue-job-scripts/${each.value}.py"
  }
}