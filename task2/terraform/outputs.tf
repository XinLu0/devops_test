output "alb_dns_name" {
  description = "ALB DNS name — open in browser to see the app"
  value       = module.ecs.alb_dns_name
}

output "ecr_repository_url" {
  description = "ECR repository URL for pushing Docker images"
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs.service_name
}

output "waf_web_acl_arn" {
  description = "WAF Web ACL ARN protecting the ALB"
  value       = module.waf.web_acl_arn
}
