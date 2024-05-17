#Creating VPC
resource "aws_vpc" "main" {
 cidr_block = var.vpc_cidr
 
 enable_dns_hostnames = true

 tags = {
    Name        = "ecs-vpc"
    Terraform   = "true"
    Environment = "dev"
 }
}
#Creating Subnets

//wirting this line to test tflint
resource "aws_subnet" "subnet" {
 vpc_id                  = aws_vpc.main.id
 cidr_block              = "10.0.1.0/24"
 map_public_ip_on_launch = true
 availability_zone       = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
 vpc_id                  = aws_vpc.main.id
 cidr_block              = "10.0.0.0/24"
 map_public_ip_on_launch = true
 availability_zone       = "us-east-1b"
}

resource "aws_subnet" "subnet3" {
 vpc_id                  = aws_vpc.main.id
 cidr_block              = "10.0.2.0/24"
 map_public_ip_on_launch = true
 availability_zone       = "us-east-1b"
}

#creating SG
 resource "aws_security_group" "security_group" {
 name   = "ecs-security-group"
 vpc_id = aws_vpc.main.id

 ingress {
   from_port   = 0
   to_port     = 0
   protocol    = -1
   self        = "false"
   cidr_blocks = ["0.0.0.0/0"]
   description = "any"
 }

 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

#creating rtb
resource "aws_route_table" "route_table" {
 vpc_id = aws_vpc.main.id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.internet_gateway.id
 }
}

resource "aws_route_table_association" "subnet_route" {
 subnet_id      = aws_subnet.subnet.id
 route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet2_route" {
 subnet_id      = aws_subnet.subnet2.id
 route_table_id = aws_route_table.route_table.id
}

#creating igw
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "internet_gateway"
  }
}


#creating ALB

resource "aws_lb" "ecs_alb" {
 name               = "ecs-alb"
 internal           = false
 #Terraform keeps destroying internet gateway forever, deletion protection ==> false
 enable_deletion_protection = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.security_group.id]
 subnets            = [aws_subnet.subnet.id, aws_subnet.subnet2.id]

 tags = {
   Name = "ecs-alb"
 }
}

resource "aws_lb_listener" "ecs_alb_listener" {
 load_balancer_arn = aws_lb.ecs_alb.arn
 port              = 80
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.ecs_tg.arn
 }
}

resource "aws_lb_target_group" "ecs_tg" {
 name        = "ecs-target-group"
 port        = 80
 protocol    = "HTTP"
 target_type = "ip"
 vpc_id      = aws_vpc.main.id

 health_check {
   path = "/"
 }
}



/*
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


  
}*/

# for creating DB subnet grps

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.subnet.id, aws_subnet.subnet2.id]

  tags = {
    Name = "My DB subnet group"
  }
}










