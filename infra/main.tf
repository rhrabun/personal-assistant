resource "aws_s3_bucket" "backup" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_public_access_block" "backup" {
  bucket                  = aws_s3_bucket.backup.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup" {
  bucket = aws_s3_bucket.backup.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_iam_user" "backup" {
  name = var.iam_user_name
  tags = var.tags
}

resource "aws_iam_policy" "backup" {
  name        = "${var.iam_user_name}-s3"
  description = "restic backup bucket access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetBucketLocation", "s3:ListBucket"]
        Resource = aws_s3_bucket.backup.arn
      },
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject", "s3:AbortMultipartUpload"]
        Resource = "${aws_s3_bucket.backup.arn}/*"
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "backup" {
  user       = aws_iam_user.backup.name
  policy_arn = aws_iam_policy.backup.arn
}
