resource "aws_ecr_repository" "wordPress" {
  name  = "wordpress"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}