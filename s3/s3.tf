resource "aws_s3_bucket" "jack-petclinic-bucket" {
  bucket = var.bucket_name

  tags = var.mytags
}

resource "aws_s3_bucket_acl" "jack-petclinic-bucket-acl" {
  bucket = aws_s3_bucket.jack-petclinic-bucket.id
  acl    = "private"
}