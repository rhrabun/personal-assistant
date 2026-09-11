output "backup_bucket" {
  description = "Name of the backup bucket."
  value       = aws_s3_bucket.backup.id
}

output "backup_bucket_arn" {
  description = "ARN of the backup bucket."
  value       = aws_s3_bucket.backup.arn
}

output "backup_iam_user" {
  description = "Name of the IAM user restic runs as."
  value       = aws_iam_user.backup.name
}

output "backup_iam_user_arn" {
  description = "ARN of the restic IAM user."
  value       = aws_iam_user.backup.arn
}
