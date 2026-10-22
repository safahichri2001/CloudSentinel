
# ============================================================
# CloudSentinel - CloudWatch Monitoring
# ============================================================

# Monitor backend CPU utilization.
# CloudWatch receives EC2 basic monitoring metrics automatically.

resource "aws_cloudwatch_metric_alarm" "backend_cpu_high" {
  count = var.enable_app ? 1 : 0

  alarm_name          = "cloudsentinel-backend-cpu-high"
  alarm_description   = "Backend EC2 CPU utilization is consistently high."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.backend[0].id
  }

  tags = {
    Name        = "cloudsentinel-backend-cpu-alarm"
    Project     = "CloudSentinel"
    Environment = "lab"
  }
}

# Monitor unhealthy backend targets behind the ALB.

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  count = var.enable_app ? 1 : 0

  alarm_name          = "cloudsentinel-alb-unhealthy-targets"
  alarm_description   = "The ALB has at least one unhealthy backend target."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Maximum"
  threshold           = 1
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.cloudsentinel[0].arn_suffix
    TargetGroup  = aws_lb_target_group.cloudsentinel[0].arn_suffix
  }

  tags = {
    Name        = "cloudsentinel-alb-unhealthy-alarm"
    Project     = "CloudSentinel"
    Environment = "lab"
  }
}
