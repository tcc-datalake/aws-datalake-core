output s3_bucket_raw {
  value = module.s3_raw
}

output s3_bucket_trusted {
  value = module.s3_trusted
}

output s3_bucket_refined {
  value = module.s3_refined
}

output s3_bucket_assets {
  value = module.s3_assets
}

output s3_athena_results {
  value = module.s3_athena_results
}

output s3_bucket_glue_jobs {
  value = module.s3_glue_job_scripts
}