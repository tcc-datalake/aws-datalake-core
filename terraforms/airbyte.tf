
module "ec2" {
  source            = "./ec2"
  security_group_id = module.networking.security_group_id
  subnet_id         = module.networking.subnet_id
  instance_type     = "t2.micro"
  storage_size      = 10
  tag               = "ec2-${var.name_tag}"
  application_name  = "airbyte"
}