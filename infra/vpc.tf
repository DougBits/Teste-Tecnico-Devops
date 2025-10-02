## Primeiro vamos criar a VPC e as Subnets, levando em consideração que não existem ainda.

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.4.0"

# Damos um nome e um range de IPs a VPC
  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

# Definimos as zonas de disponibilidade
  azs = ["${var.aws_region}a", "${var.aws_region}b"]

# Definimos as Subnets sendo privadas para os nodes e pods e públicas para os Loadbalancers
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

# Habilitamos o NAT para que elas acessem a internet
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Project = var.cluster_name
  }
}
