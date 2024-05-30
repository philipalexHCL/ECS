# To create EcsTaskExecutionRole for ECS

resource "aws_iam_role" "EcsTaskExecutionRole" {
  name = "EcsTaskExecutionRole"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "POC"
  }
}


resource "aws_iam_role_policy" "AccessSecretsAndParameters_policy" {
  name = "AccessSecretsAndParameters"
  role = aws_iam_role.EcsTaskExecutionRole.id


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Resource = [
		   "arn:aws:secretsmanager:us-east-1:${var.AWSAccount}:secret:rds*"
		]
		Effect   = "Allow"
      },
	  {
        Action = [
          "ssm:GetParameters",
        ]
        Resource = [
		   "arn:aws:ssm:us-east-1:${var.AWSAccount}:parameter/dev/*"
		]
		Effect   = "Allow"
      },
    ]
  })
}

data "aws_iam_policy" "ECS_service_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ECS_service_role_policy_attach" {
   role       = "${aws_iam_role.EcsTaskExecutionRole.name}"
   policy_arn = "${data.aws_iam_policy.ECS_service_policy.arn}"
}


# To create EcsTaskRole for ECS


resource "aws_iam_role" "EcsTaskRole" {
  name = "EcsTaskRole"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "POC"
  }
}


resource "aws_iam_role_policy" "AccessSecretsAndParameter_policy" {
  name = "AccessSecretsAndParameters"
  role = aws_iam_role.EcsTaskRole.id


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Resource = [
		   "arn:aws:secretsmanager:us-east-1:${var.AWSAccount}:secret:rds*"
		]
		Effect   = "Allow"
      },
	  {
        Action = [
          "ssm:GetParameters",
        ]
        Resource = [
		   "arn:aws:ssm:us-east-1:${var.AWSAccount}:parameter/dev/*"
		]
		Effect   = "Allow"
      },
    ]
  })
}

