module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # Definições do Cluster
  name                    = var.cluster_name
  kubernetes_version      = "1.29"
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = concat(module.vpc.private_subnets, module.vpc.public_subnets)

# Definição dos Workers (vamos usar só um, mas com um +1 no maxsize para o caso de sobrecarga)
  eks_managed_node_groups = {
    teste-tecnico = {
      name           = "teste-tecnico"
      instance_types = [var.node_instance_type]
      desired_size   = var.desired_capacity
      max_size       = var.desired_capacity + 1
      min_size       = 1
      disk_size      = 20

      tags = {
        Project = var.cluster_name
      }
    }
  }

  tags = {
    Project = var.cluster_name
  }
}