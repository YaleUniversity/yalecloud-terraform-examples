provider "aws" {
  region = "us-east-1"
}

# place other specific actions for related resources here.

# write access logs to specific S3 bucket

data "aws_elb_service_account" "main" {}

data "aws_canonical_user_id" "current_user" {}

resource "aws_s3_bucket" "bucket" {
  bucket = "example-app-access-logs"
  grant {
    type        = "Group"
    permissions = ["FULL_CONTROL"]
    uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
  }
  grant {
    id          = data.aws_canonical_user_id.current_user.id
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
       "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::example-app-access-logs/*"
      ],
      "Principal": {
        "AWS": [
         "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
EOF
}

