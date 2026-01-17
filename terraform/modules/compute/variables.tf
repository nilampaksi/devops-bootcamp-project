variable "project" {
  description = "Base project name for all resources"
  type        = string
}

variable "prefix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "vpc_id" {}

variable "vpc_cidr" {}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "instances" {
  type = map(object({
    name        = string
    subnet_type = string
    role = string
    private_ip = string
  }))
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type = number
}
