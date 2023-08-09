module "networking" {
  source               = "./networking"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = "10.0.1.0/24"
  region               = var.region
  availability_zones   = "us-east-1a"
  tag                  = "networking-${var.name_tag}"
}

module "ec2" {
  source            = "./ec2"
  security_group_id = module.networking.security_group_id
  subnet_id         = module.networking.subnet_id
  instance_type     = "t2.micro"
  storage_size      = 10
  tag               = "ec2-${var.name_tag}"
}