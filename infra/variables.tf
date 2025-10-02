variable "aws_region" {
  type    = string
  default = "sa-east-1"
}

variable "cluster_name" {
  type    = string
  default = "teste-tecnico-eks"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "node_instance_type" {
  type    = string
  default = "t3.small"
}

variable "desired_capacity" {
  type    = number
  default = 2
}
