# -----------------------------------------------------------------------------
# Local values - container definition
# -----------------------------------------------------------------------------
locals {
  container_definitions = [
    merge(
      {
        name      = "s3-browser"
        image     = var.app_image
        essential = true

        portMappings = [
          {
            containerPort = var.app_port
            hostPort      = var.app_port
            protocol      = "tcp"
            appProtocol   = "http"
          }
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            "awslogs-group"         = aws_cloudwatch_log_group.s3_browser.name
            "awslogs-region"        = data.aws_region.current.region
            "awslogs-stream-prefix" = "ecs"
          }
        }

        # Pass bucket name and region so the health check can verify S3 access via task role
        environment = [
          { name = "S3_BUCKET", value = aws_s3_bucket.sample.id },
          { name = "AWS_DEFAULT_REGION", value = data.aws_region.current.region }
        ]

        # Health check: same ls as startup (task role must list bucket)
        healthCheck = {
          command     = ["CMD-SHELL", "aws s3 ls s3://$S3_BUCKET --region $AWS_DEFAULT_REGION || exit 1"]
          interval    = 30
          timeout     = 15
          retries     = 3
          startPeriod = 90
        }
      },
      merge(
        length(var.app_command) > 0 ? { command = var.app_command } : {},
        length(var.app_entrypoint) > 0 ? { entryPoint = var.app_entrypoint } : {}
      )
    )
  ]
}
