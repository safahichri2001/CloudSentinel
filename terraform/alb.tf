resource "aws_lb" "cloudsentinel" {
  name               = "cloudsentinel-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name        = "cloudsentinel-alb"
    Project     = "CloudSentinel"
    Environment = "lab"
  }
}
# ============================================================
# CloudSentinel - Target Group
# ============================================================

resource "aws_lb_target_group" "cloudsentinel" {
  name        = "cloudsentinel-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.cloudsentinel.id
  target_type = "ip"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "cloudsentinel-tg"
    Project     = "CloudSentinel"
    Environment = "lab"
  }
}

# ============================================================
# CloudSentinel - HTTP Listener
# ============================================================

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.cloudsentinel.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cloudsentinel.arn
  }

  tags = {
    Name        = "cloudsentinel-http-listener"
    Project     = "CloudSentinel"
    Environment = "lab"
  }
}