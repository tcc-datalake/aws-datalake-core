resource "aws_s3_bucket" "raw_bucket" {
  bucket        = "raw-tcc-impacta-infra-datalake-5"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "raw_bucket" {
  bucket = aws_s3_bucket.raw_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "raw_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.raw_bucket]

  bucket = aws_s3_bucket.raw_bucket.id
  acl    = "private"
}
