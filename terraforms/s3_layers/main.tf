module "s3_raw" {
  source = "../s3"
  bucket_name = "${var.name_tag}-raw"
}
module "s3_trusted" {
  source = "../s3"
  bucket_name = "${var.name_tag}-trusted"
}
module "s3_refined" {
  source = "../s3"
  bucket_name = "${var.name_tag}-refined"
}
module "s3_assets" {
  source = "../s3"
  bucket_name = "${var.name_tag}-assets"
}
module "s3_athena_results" {
  source = "../s3"
  bucket_name = "${var.name_tag}-athena-query-results"
}