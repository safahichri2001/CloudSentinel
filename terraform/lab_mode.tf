# ============================================================
# CloudSentinel - Lab lifecycle management
# ============================================================

variable "enable_app" {
  description = "Enable or disable billable application resources"
  type        = bool
  default     = false
}

# Preserve existing Terraform resource addresses when adding count.

moved {
  from = aws_instance.backend
  to   = aws_instance.backend[0]
}

moved {
  from = aws_lb.cloudsentinel
  to   = aws_lb.cloudsentinel[0]
}

moved {
  from = aws_lb_target_group.cloudsentinel
  to   = aws_lb_target_group.cloudsentinel[0]
}

moved {
  from = aws_lb_listener.http
  to   = aws_lb_listener.http[0]
}

moved {
  from = aws_lb_target_group_attachment.backend
  to   = aws_lb_target_group_attachment.backend[0]
}