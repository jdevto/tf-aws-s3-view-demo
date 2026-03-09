# -----------------------------------------------------------------------------
# ECS Task Definition and Service
# -----------------------------------------------------------------------------
resource "aws_ecs_task_definition" "s3_browser" {
  family                   = "${var.environment}-s3-browser"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  tags                     = merge(var.tags, { Name = "${var.environment}-s3-browser" })

  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode(local.container_definitions)
}

resource "aws_ecs_service" "s3_browser" {
  name            = "${var.environment}-s3-browser"
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.s3_browser.arn
  desired_count   = var.desired_count
  launch_type     = "EC2"
  tags            = merge(var.tags, { Name = "${var.environment}-s3-browser" })

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.tasks.id]
    assign_public_ip = false
  }
}
