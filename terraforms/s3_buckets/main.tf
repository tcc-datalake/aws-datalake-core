module "s3_raw" {
  source      = "../s3"
  bucket_name = "${var.name_tag}-raw"
}

module "s3_trusted" {
  source      = "../s3"
  bucket_name = "${var.name_tag}-trusted"
}

module "s3_refined" {
  source      = "../s3"
  bucket_name = "${var.name_tag}-refined"
}

module "s3_assets" {
  source      = "../s3"
  bucket_name = "${var.name_tag}-assets"
}

module "s3_athena_results" {
  source      = "../s3"
  bucket_name = "${var.name_tag}-athena-query-results"
}

module "s3_glue_job_scripts" {
  source      = "../s3"
  bucket_name = "${var.name_tag}-glue-job-scripts"
}

resource "aws_s3_object" "upload_glue_jobs" {
  for_each = { for job in var.jobs : job => regex(".*\\/jobs\\/(.*)\\.py", job)[0] }

  bucket = "${var.name_tag}-glue-job-scripts"
  key    = "${each.value}.py"
  source = "${path.module}/../../application/jobs/${each.value}.py"
  etag    = "${filemd5("${path.module}/../../application/jobs/${each.value}.py")}"

  depends_on = [ module.s3_glue_job_scripts ]
}

module "s3_dags" {
  source      = "../s3"
  bucket_name = "${var.name_tag}-dags"
}