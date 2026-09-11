# Backup infra

Terraform for the S3 bucket and IAM user used by the restic backup role.

## Usage

Create the remote state bucket once, then:

```sh
cd infra
cp backend.tfvars.example backend.tfvars   # fill <state-bucket>
terraform init -backend-config=backend.tfvars
terraform apply \
  -var="bucket_name=<backup-bucket>" \
  -var="iam_user_name=<iam-user>"
aws iam create-access-key --user-name <iam-user>
```

The access key is created outside Terraform so it never lands in state. Put the
key and the restic passphrase into `ansible/inventory.yml`.

Requires Terraform >= 1.16 and AWS credentials allowed to manage S3 and IAM.
