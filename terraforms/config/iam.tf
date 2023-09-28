module "iam" {
  source                    = "../iam"
  aws_s3_raw_bucket_arn     = module.s3_buckets.s3_bucket_raw.arn
  aws_s3_trusted_bucket_arn = module.s3_buckets.s3_bucket_trusted.arn
  aws_s3_refined_bucket_arn = module.s3_buckets.s3_bucket_refined.arn
  aws_s3_glue_jobs_arn      = module.s3_buckets.s3_bucket_glue_jobs.arn
  region                    = var.region
}
