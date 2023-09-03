resource "aws_ecr_repository" "airflow_repository" {
    name = "airflow"
    force_delete = true
}

resource "aws_ecr_lifecycle_policy" "airflow_repository_lifecycly" {
    repository = aws_ecr_repository.airflow_repository.name

    policy = jsonencode({
        "rules": [
            {
                "rulePriority": 1,
                "description": "Keep only the latest image",
                "selection": {
                    "tagStatus": "any",
                    "countType": "imageCountMoreThan",
                    "countNumber": 1
                },
                "action": {
                    "type": "expire"
                }
            }
        ]
    })
}