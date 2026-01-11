terraform {
  backend "s3" {
    bucket       = "devops-bootcamp-terraform-muhaimin"
    key          = "terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}
