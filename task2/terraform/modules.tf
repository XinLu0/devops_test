# ---------- Modularised infrastructure ----------

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  aws_region   = var.aws_region
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "ecs" {
  source         = "./modules/ecs"
  project_name   = var.project_name
  aws_region     = var.aws_region
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  repository_url = module.ecr.repository_url
  image_tag      = var.image_tag
  container_port = var.container_port
  desired_count  = var.desired_count
  cpu            = var.cpu
  memory         = var.memory
}

module "monitoring" {
  source             = "./modules/monitoring"
  project_name       = var.project_name
  ecs_cluster_name   = module.ecs.cluster_name
  ecs_service_name   = module.ecs.service_name
  alb_arn_suffix     = module.ecs.alb_arn_suffix
  target_group_arn_suffix = module.ecs.target_group_arn_suffix
}

module "waf" {
  source       = "./modules/waf"
  project_name = var.project_name
  alb_arn      = module.ecs.alb_arn
}
