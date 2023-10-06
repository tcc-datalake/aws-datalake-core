module "efs" {
  source = "../efs"

  subnet_id                  = module.networking.airflow_public_subnet
  security_group_efs_airflow = module.networking.security_group_efs_airflow
  tag                        = "efs-${var.name_tag}"
}
