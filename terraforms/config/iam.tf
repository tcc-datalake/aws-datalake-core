module "iam" {
  source                = "../iam"
  aws_s3_raw_bucket_arn = module.s3_layers.s3_bucket_raw.arn
  aws_s3_trusted_bucket_arn = module.s3_layers.s3_bucket_trusted.arn
  aws_s3_refined_bucket_arn = module.s3_layers.s3_bucket_refined.arn
  region                = var.region
}