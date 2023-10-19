resource "aws_s3_bucket_policy" "jack-petclinic-policy" {
  bucket = aws_s3_bucket.jack-petclinic-bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "CH10JackPetclinicPolicy",
  "Statement": [
     {
         "Effect": "Allow",
         "Principal": "*",
         "Action": "s3:ListBucket",
         "Resource": "arn:aws:s3:::ch10jackpetclinicbucket"
     },
     {
         "Effect": "Allow",
         "Principal": "*",
         "Action": [
             "s3:GetObject",
             "s3:PutObject",
             "s3:DeleteObject"
         ],
         "Resource": "arn:aws:s3:::ch10jackpetclinicbucket/*"
     }

  ]
}
POLICY
}