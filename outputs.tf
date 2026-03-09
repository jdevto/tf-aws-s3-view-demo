output "log_group_name" {
  description = "CloudWatch log group for S3 browser tasks."
  value       = aws_cloudwatch_log_group.s3_browser.name
}

output "sample_bucket_id" {
  description = "Sample S3 bucket ID (task role has access)."
  value       = aws_s3_bucket.sample.id
}

output "sample_bucket_arn" {
  description = "Sample S3 bucket ARN."
  value       = aws_s3_bucket.sample.arn
}
