output "instance_ids" {
  value = module.compute.instance_ids
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.app.repository_url
}

