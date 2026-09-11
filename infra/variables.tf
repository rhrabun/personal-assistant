variable "region" {
  description = "AWS region for the backup bucket."
  type        = string
  default     = "eu-central-1"
}

variable "bucket_name" {
  description = "S3 bucket that holds restic backups."
  type        = string
}

variable "iam_user_name" {
  description = "IAM user restic authenticates as."
  type        = string
}

variable "tags" {
  description = "Tags applied to created resources."
  type        = map(string)
  default = {
    Project   = "personal-assistant"
    ManagedBy = "terraform"
  }
}