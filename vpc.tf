# -----------------------------------------------------------------------------
# Security group for ECS tasks (no ALB)
# -----------------------------------------------------------------------------
resource "aws_security_group" "tasks" {
  name        = "${var.environment}-s3-browser-tasks"
  description = "S3 browser ECS tasks"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.environment}-s3-browser-tasks" })

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "S3 browser app port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
