variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "alb_arn" {
  description = "Full ARN of the ALB to associate the WAF Web ACL with"
  type        = string
}
