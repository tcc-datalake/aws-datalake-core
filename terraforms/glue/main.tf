resource "aws_glue_catalog_database" "raw_db" {
  name = "raw_database"
}

resource "aws_glue_catalog_table" "raw_table" {
  name   = replace(var.aws_s3_raw_bucket_id, "-", "_")
  database_name = aws_glue_catalog_database.raw_db.name
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location = "s3://${var.aws_s3_raw_bucket_id}/"
  }
}

resource "aws_glue_crawler" "raw_crawler" {
  name          = "raw_crawler"
  role          = var.aws_glue_role_arn
  database_name = aws_glue_catalog_database.raw_db.name

  s3_target {
    path = "s3://${var.aws_s3_raw_bucket_id}/"
  }
}

