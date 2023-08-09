output "security_group_id" {
  value = aws_security_group.security_group_ec2.id
}

output "subnet_id" {
  value = aws_subnet.public_subnet.id
}