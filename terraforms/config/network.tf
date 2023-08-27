module "networking" {
  source               = "../networking"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = "10.0.1.0/24"
  region               = var.region
  availability_zones   = "us-east-1a"
  tag                  = "networking-${var.name_tag}"
}