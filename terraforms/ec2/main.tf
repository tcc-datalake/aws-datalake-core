resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "auth_ssh" {
  key_name = "ec2_key_pair"
  public_key = tls_private_key.key.public_key_openssh


  provisioner "local-exec" {
    command = "echo '${tls_private_key.key.private_key_pem}' > aws-datalake-'${var.application_name}'.pem"
  }
}

resource "aws_instance" "ec2" {
  instance_type          = var.instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.auth_ssh.id
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id
  user_data              = var.application_template

  root_block_device {
    volume_size = var.storage_size
  }

  tags = {
    Name = var.tag
  }
}