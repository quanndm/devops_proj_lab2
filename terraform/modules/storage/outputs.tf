output "mongodb_private_ip" {
  value = aws_instance.mongodb-instance.private_ip
}

output "mongodb_public_ip" {
  value = aws_instance.mongodb-instance.public_ip
}

output "mongodb_public_dns" {
  value = aws_instance.mongodb-instance.public_dns
}

output "mongodb_instance_id" {
  value = aws_instance.mongodb-instance.id
}
