# CloudSentinel - ALB Security Group

resource "aws_security_group" "alb" {
  name        = "cloudsentinel-alb-sg"
  description = "Security group for the CloudSentinel Application Load Balancer"
  vpc_id      = aws_vpc.cloudsentinel.id

  tags = {
    Name        = "cloudsentinel-alb-sg"
    Project     = "CloudSentinel"
    Environment = "lab"
  }
}

# HTTPS ingress
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTPS traffic from the Internet"

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443

  cidr_ipv4 = "0.0.0.0/0"
}

# HTTP ingress - temporary for the lab
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTP traffic from the Internet"

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  cidr_ipv4 = "0.0.0.0/0"
}

# Allow outbound traffic
resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id

  description = "Allow outbound traffic"

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}