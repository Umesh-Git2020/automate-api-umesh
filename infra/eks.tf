data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available" {

}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.22.0"
  cluster_name = var.cluster_name
  cluster_version = "1.24"
  subnets = module.vpc.private_subnets
  cluster_create_timeout = "1h"
  cluster_endpoint_private_access = true
  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name = "worker-group-1"
      instance_type = "t2.small"
      asg_desired_capacity = 1
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    }
  ]
  
  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
}

provider "kubernetes" {
  host = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.cluster.token
}

resource "kubernetes_deployment" "automate-all-the-things" {

  metadata {
    name = "automate-all-the-things"
    labels = {
      "app.kubernetes.io/name" =  "automate-all-the-things"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        "app.kubernetes.io/name" =  "automate-all-the-things"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" =  "automate-all-the-things"
        }
      }
    
      spec {
        container {
          image = "docker.io/umeshnataraj/automate-all-the-things:latest"
          name = "rest-api"
        
          resources {
            limits = {
              cpu = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "automate-all-the-things" {
  metadata {
    name = "terraform-example"
  }
  spec {
    selector = {
      "app.kubernetes.io/name" =  "automate-all-the-things"
    }
    port {
      port = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}

locals {
  lb_hostname = kubernetes_service.automate-all-the-things.status.0.load_balancer.0.ingress.0.hostname
}

