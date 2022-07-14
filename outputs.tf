output "instance_ip_addr" {
  value = aws_instance.qytang_ec2.private_ip
}

output "instance_public_ip_addr" {
  value = aws_instance.qytang_ec2.public_ip
}

output "instance_public_sg" {
  value = aws_instance.qytang_ec2.security_groups
}