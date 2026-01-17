resource "aws_ecr_repository" "app" {
  name = "devops-bootcamp/final-project-muhaimin"
  force_delete = true

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

}

resource "aws_ecr_repository" "node_exporter" {
  name                 = "monitoring/node-exporter"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "prometheus" {
  name                 = "monitoring/prometheus"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "grafana" {
  name                 = "monitoring/grafana"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

