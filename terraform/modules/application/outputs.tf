output "application_public_ip" {
  value = aws_instance.application-instance.public_ip
}

output "application_public_dns" {
  value = aws_instance.application-instance.public_dns
}

output "application_instance_id" {
  value = aws_instance.application-instance.id
}
