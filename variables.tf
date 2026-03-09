variable "ecs_cluster_arn" {
  description = "ARN of the existing ECS cluster (EC2 launch type)."
  type        = string
}

variable "vpc_id" {
  description = "ID of the existing VPC."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS tasks."
  type        = list(string)
}

variable "environment" {
  description = "Environment name, used as prefix in resource names (e.g. dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "desired_count" {
  description = "Number of S3 browser tasks to run."
  type        = number
  default     = 1
}

variable "app_port" {
  description = "Port the S3 browser app listens on (default 8000)."
  type        = number
  default     = 8000
}

variable "app_image" {
  description = "Container image. Default has AWS CLI so the health check can verify S3 access via the task role."
  type        = string
  default     = "amazon/aws-cli:latest"
}

variable "app_command" {
  description = "Container command. Loop: write timestamped file to bucket, ls, sleep 60s, repeat."
  type        = list(string)
  default     = ["while true; do ts=$(date +%Y%m%d-%H%M%S); printf '%s' \"$ts\" > /tmp/s.txt; aws s3 cp /tmp/s.txt s3://$S3_BUCKET/$ts.txt --region $AWS_DEFAULT_REGION; aws s3 ls s3://$S3_BUCKET --region $AWS_DEFAULT_REGION; sleep 60; done"]
}

variable "app_entrypoint" {
  description = "Container entrypoint. Default runs app_command in a shell (required for amazon/aws-cli image)."
  type        = list(string)
  default     = ["/bin/sh", "-c"]
}

variable "tags" {
  description = "Tags to apply to all taggable resources. Merged with resource-specific tags."
  type        = map(string)
  default     = {}
}

variable "task_s3_path_prefix" {
  description = "Optional S3 path prefix to restrict task role access (e.g. 'data/'). Empty = whole bucket."
  type        = string
  default     = ""
}
