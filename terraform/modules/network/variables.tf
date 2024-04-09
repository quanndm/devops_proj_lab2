
variable "cidr_block" {
  type     = string
  nullable = false
}

variable "availability_zones" {
  description = "list of az when create vpc"
  nullable    = false
}

variable "public_subnets" {
  type        = list(any)
  nullable    = false
  description = "list of public subnet depend on vpc cidr block"
}


variable "private_subnets" {
  type        = list(any)
  nullable    = false
  description = "list of private subnet depend on vpc cidr block"
}

variable "environment" {
  type = string
}


