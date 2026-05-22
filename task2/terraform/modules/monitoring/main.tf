# ---------- Monitoring Module ----------
# CloudWatch alarms for CPU, memory, and unhealthy hosts + SNS notifications.

# ---------- SNS Topic ----------

resource "aws_sns_topic" "alarms" {
  name         = "${var.project_name}-alarms"
  display_name = "DevOps Test Alarm Notifications"

  tags = {
    Name = "${var.project_name}-alarms"
  }
}

# ---------- CPU Alarm ----------

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  alarm_description   = "Alarm when average CPU exceeds 80% for 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = [aws_sns_topic.alarms.arn]

  tags = {
    Name = "${var.project_name}-high-cpu"
  }
}

# ---------- Memory Alarm ----------

resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name          = "${var.project_name}-high-memory"
  alarm_description   = "Alarm when average memory exceeds 80% for 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = [aws_sns_topic.alarms.arn]

  tags = {
    Name = "${var.project_name}-high-memory"
  }
}

# ---------- Unhealthy Host Alarm ----------

resource "aws_cloudwatch_metric_alarm" "unhealthy_host" {
  alarm_name          = "${var.project_name}-unhealthy-host"
  alarm_description   = "Alarm when there is at least one unhealthy target"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Maximum"
  threshold           = 1
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  alarm_actions = [aws_sns_topic.alarms.arn]

  tags = {
    Name = "${var.project_name}-unhealthy-host"
  }
}
