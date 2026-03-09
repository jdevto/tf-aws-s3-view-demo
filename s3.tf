# -----------------------------------------------------------------------------
# Sample S3 bucket (task role gets access via IAM policy in iam.tf)
# -----------------------------------------------------------------------------
resource "random_id" "bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "sample" {
  bucket        = "${var.environment}-s3-browser-sample-${random_id.bucket.hex}"
  force_destroy = true

  tags = merge(var.tags, { Name = "${var.environment}-s3-browser-sample" })
}

resource "aws_s3_bucket_public_access_block" "sample" {
  bucket = aws_s3_bucket.sample.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
