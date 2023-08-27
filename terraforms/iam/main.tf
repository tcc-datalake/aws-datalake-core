resource "aws_iam_policy" "glue_s3_policy" {
  name = "glue_s3_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      Effect   = "Allow",
      Resource = [
        "${var.aws_s3_raw_bucket_arn}",
        "${var.aws_s3_raw_bucket_arn}/*"
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
      Effect   = "Allow",
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

  inline_policy {
    name = aws_iam_policy.glue_s3_policy.name
    policy = aws_iam_policy.glue_s3_policy.policy
  }

  inline_policy {
    name = aws_iam_policy.glue_cloudwatch_policy.name
    policy = aws_iam_policy.glue_cloudwatch_policy.policy
  }

  inline_policy {
    name = aws_iam_policy.glue_catalog_policy.name
    policy = aws_iam_policy.glue_catalog_policy.policy
  }
}
