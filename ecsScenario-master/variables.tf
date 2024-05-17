variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}


variable "AWSAccount" {
  description = "AWS Account ID"
  type        = number
}

variable "RDSsecret" {
  description = "RDS Secret ARN"
  type        = string
}