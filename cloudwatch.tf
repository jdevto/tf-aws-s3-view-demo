# -----------------------------------------------------------------------------
# CloudWatch Logs
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "s3_browser" {
  name             = "/ecs/${var.environment}-s3-browser"
  retention_in_days = 1
  skip_destroy     = false

  tags = merge(var.tags, { Name = "/ecs/${var.environment}-s3-browser" })
}
