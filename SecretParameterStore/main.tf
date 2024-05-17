resource "aws_ssm_parameter" "secret" {
  name        = "/dev/WORDPRESS_DB_HOST"
  description = "The parameter description"
  type        = "String"
  value       = "wordpress.czk6sws08u57.us-east-1.rds.amazonaws.com:3306"

  tags = {
    environment = "POC"
  }
}

resource "aws_ssm_parameter" "secret2" {
  name        = "/dev/WORDPRESS_DB_NAME"
  description = "The parameter description"
  type        = "SecureString"
  value       = "wordpress"

  tags = {
    environment = "POC"
  }
}