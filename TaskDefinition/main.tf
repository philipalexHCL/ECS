resource "aws_ecs_task_definition" "wordpress-tdN" {
  family                   = "wordpress-tdN"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn = "arn:aws:iam::${var.AWSAccount}:role/EcsTaskExecutionRole"
  task_role_arn = "arn:aws:iam::${var.AWSAccount}:role/EcsTaskRole"
  cpu                      = 1024
  memory                   = 2048
 
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
 container_definitions = <<TASK_DEFINITION
[
  {
    "cpu": 256,
   "secrets": [{
        "name": "WORDPRESS_DB_HOST",
        "valueFrom": "arn:aws:ssm:us-east-1:${var.AWSAccount}:parameter/dev/WORDPRESS_DB_HOST"
    },
	{
        "name": "WORDPRESS_DB_NAME",
        "valueFrom": "arn:aws:ssm:us-east-1:${var.AWSAccount}:parameter/dev/WORDPRESS_DB_NAME"
    },
	{
        "name": "WORDPRESS_DB_USER",
        "valueFrom": "${var.RDSsecret}:username::"
		
    },
	{
        "name": "WORDPRESS_DB_PASSWORD",
        "valueFrom": "${var.RDSsecret}:password::"
    }
	
	], 
    "essential": true,
    "image": "${var.AWSAccount}.dkr.ecr.us-east-1.amazonaws.com/wordpress:latest",
    "memory": 512,
    "name": "myctnr",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
TASK_DEFINITION


  
}