variable "project" {
  description = "Base name for all resources"
  type        = string
}

variable "region" {
  default = "ap-southeast-1"
}

variable "ami" {}

variable "instance_type" {
  default = "t3.micro"
}

variable "instances" {
  type = map(object({
    name        = string
    subnet_type = string
    role        = string
    private_ip  = string
  }))
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 30
}
