
output "mognodb_sg_id" {
  value = aws_security_group.mongodb-sg.id
}

output "application_sg_id" {
  value = aws_security_group.application-sg.id
}
