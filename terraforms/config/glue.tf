locals {
  database_config = jsondecode(file("../../application/databases.json"))

  combined_names = flatten([for database in local.database_config : [for layer in database.layers : "${layer}_${database.database}"]])

  combined_names_map = {
    for name in local.combined_names : name => ""
  }
}

module "glue_catalog_crawler" {
  for_each            = local.combined_names_map
  source              = "../glue/catalogs_crawlers"
  database_name       = each.key
  database_s3_path    = "s3://${join("-", [var.name_tag, element(split("_", each.key), 0)])}/database=${each.key}/"
  aws_glue_role_arn   = module.iam.glue_role_arn
  table_level_in_path = 3
  name_tag            = var.name_tag
}

module "glue_jobs" {
  source              = "../glue/jobs"
  aws_glue_role_arn   = module.iam.glue_role_arn
  jobs                = fileset(path.module, "../../application/jobs/*.py")
  name_tag            = var.name_tag
}
