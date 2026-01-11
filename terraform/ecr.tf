resource "aws_ecr_repository" "app" {
  name = "devops-bootcamp/final-project-muhaimin"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

}

