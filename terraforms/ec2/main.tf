resource "aws_key_pair" "auth_ssh" {
  key_name = "ec2_key_pair"
  public_key = file("~/.ssh/aws-datalake-core.pub")
}

resource "aws_instance" "ec2" {
  instance_type          = var.instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.auth_ssh.id
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id
  user_data              = base64encode(file("${path.module}/template/EC2.tpl"))

  root_block_device {
    volume_size = var.storage_size
  }

  tags = {
    Name = var.tag
  }
}