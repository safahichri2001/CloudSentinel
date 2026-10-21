# ============================================================
# CloudSentinel - Private EC2 Backend
# ============================================================

data "aws_ssm_parameter" "al2023_ami" {
  count = var.enable_app ? 1 : 0

  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "backend" {
  count = var.enable_app ? 1 : 0

  ami           = data.aws_ssm_parameter.al2023_ami[0].value
  instance_type = "t3.micro"

  subnet_id = aws_subnet.private_1.id

  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.backend.id
  ]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  user_data = templatefile(
    "${path.module}/backend_user_data.sh.tftpl",
    {
      backend_python = file("${path.module}/../app/backend.py")
    }
  )

  tags = {
    Name        = "cloudsentinel-private-backend"
    Project     = "CloudSentinel"
    Environment = "lab"
  }
}

resource "aws_lb_target_group_attachment" "backend" {
  count = var.enable_app ? 1 : 0

  target_group_arn = aws_lb_target_group.cloudsentinel[0].arn
  target_id        = aws_instance.backend[0].private_ip
  port             = 80
}