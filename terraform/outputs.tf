output "application_public_ip" {
  value = module.application.application_public_ip
}

output "application_public_dns" {
  value = module.application.application_public_dns
}

output "application_instance_id" {
  value = module.application.application_instance_id
}

output "mongodb_private_ip" {
  value = module.storage.mongodb_private_ip
}
