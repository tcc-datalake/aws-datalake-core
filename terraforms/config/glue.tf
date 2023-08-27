module "glue" {
  source                 = "../glue"
  aws_s3_raw_bucket_arn  = module.s3.aws_s3_raw_bucket_arn
  aws_s3_raw_bucket_id   = module.s3.aws_s3_raw_bucket_id
  # aws_s3_raw_bucket_name = module.s3.aws_s3_raw_bucket_name
  aws_glue_role_arn      = module.iam.glue_role_arn
}