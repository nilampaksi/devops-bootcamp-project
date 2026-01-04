variable "prefix" {}
variable "common_tags" {
  type = map(string)
}

variable "project" {
  description = "Base project name for naming all resources"
  type        = string
}
