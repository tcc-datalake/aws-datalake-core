module "s3_buckets" {
  source   = "../s3_buckets"
  name_tag = var.name_tag
  jobs     = fileset(path.module, "../../application/jobs/*.py")
}
