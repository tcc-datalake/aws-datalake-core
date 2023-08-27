module "iam" {
  source                = "../iam"
  aws_s3_raw_bucket_arn = module.s3.aws_s3_raw_bucket_arn
  region                = var.region
}