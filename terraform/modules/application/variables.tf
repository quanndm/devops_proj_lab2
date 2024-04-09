variable "application_instance_ami" {
  type        = string
  nullable    = false
  description = "ami using for application instance"
}

variable "application_instance_type" {
  type        = string
  nullable    = false
  description = "application instance type"
}


variable "application_sg_id" {
  type        = string
  description = "security group"
  nullable    = false
}

variable "key_name" {
  type        = string
  description = "name of keypair"
  nullable    = false
}

variable "application_subnet_id" {
  type        = string
  description = "subnet id"
  nullable    = false
}

variable "environment" {
  type     = string
  nullable = false
}
