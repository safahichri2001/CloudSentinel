# ============================================================
# CloudSentinel - Private Backend Security Group
# ============================================================

resource "aws_security_group" "backend" {
  name        = "cloudsentinel-backend-sg"
  description = "Restrict access to private application backends"
  vpc_id      = aws_vpc.cloudsentinel.id

  tags = {
    Name        = "cloudsentinel-backend-sg"
    Project     = "CloudSentinel"
    Environment = "lab"
  }
}

# Only the ALB can reach the backend on TCP port 80.

resource "aws_vpc_security_group_ingress_rule" "backend_from_alb" {
  security_group_id = aws_security_group.backend.id

  description                  = "Allow application traffic from ALB only"
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  referenced_security_group_id = aws_security_group.alb.id
}