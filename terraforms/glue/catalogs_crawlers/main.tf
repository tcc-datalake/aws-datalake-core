resource "aws_glue_catalog_database" "database" {
  name = var.database_name
}

resource "aws_glue_crawler" "glue_crawler" {
  name          = var.database_name
  role          = var.aws_glue_role_arn
  database_name = var.database_name

  s3_target {
    path = var.database_s3_path
  }

  configuration = jsonencode({
    Version = 1.0,
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    },
    Grouping = {
      TableLevelConfiguration = var.table_level_in_path
    }
  })
}
