resource "aws_iam_policy" "glue_s3_policy" {
  name = "glue_s3_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      Effect = "Allow",
      Resource = [
        "${var.aws_s3_raw_bucket_arn}",
        "${var.aws_s3_raw_bucket_arn}/*",
        "${var.aws_s3_trusted_bucket_arn}",
        "${var.aws_s3_trusted_bucket_arn}/*",
        "${var.aws_s3_refined_bucket_arn}",
        "${var.aws_s3_refined_bucket_arn}/*"
      ]
    }]
  })
}

resource "aws_iam_policy" "glue_cloudwatch_policy" {
  name = "glue_cloudwatch_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Effect   = "Allow",
      Resource = "arn:aws:logs:*:*:*"
    }]
  })
}

resource "aws_iam_policy" "glue_catalog_policy" {
  name = "glue_catalog_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "glue:GetDatabase",
        "glue:UpdateTable",
        "glue:GetTable",
      ],
      Effect = "Allow",
      Resource = [
        "*"
      ]
    }]
  })
}

resource "aws_iam_role" "glue_role" {
  name = "glue_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "glue.amazonaws.com"
      }
    }]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"]
  inline_policy {
    name   = aws_iam_policy.glue_s3_policy.name
    policy = aws_iam_policy.glue_s3_policy.policy
  }

  inline_policy {
    name   = aws_iam_policy.glue_cloudwatch_policy.name
    policy = aws_iam_policy.glue_cloudwatch_policy.policy
  }

  inline_policy {
    name   = aws_iam_policy.glue_catalog_policy.name
    policy = aws_iam_policy.glue_catalog_policy.policy
  }
}

resource "aws_iam_policy" "ecs_task_policy" {
  name = "ecs-task-policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
      {
        "Action": [
          "logs:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
      {
        "Action": [
          "s3:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
      {
        "Action": [
          "elasticfilesystem:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name        = "ecs-task-role"
  description = "Allow ECS tasks to access AWS resources"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name       = aws_iam_policy.ecs_task_policy.name
    policy     = aws_iam_policy.ecs_task_policy.policy
  }
}
