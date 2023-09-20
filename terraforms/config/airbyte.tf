module "ec2_airbyte" {
  source                    = "../ec2"
  security_group_airbyte_id = module.networking.security_group_airbyte_id
  subnet_id                 = module.networking.subnet_id
  instance_type             = "t3.medium"
  storage_size              = 10
  tag                       = "ec2-${var.name_tag}"
  application_name          = "airbyte"
  application_template      = file("../ec2/templates/build_airbyte.sh")
}

resource "aws_eip" "eip_airbyte" {
  instance = module.ec2_airbyte.instance_id
}
