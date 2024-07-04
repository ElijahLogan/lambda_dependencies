# Bucket creation and ownership controls
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}
resource "aws_s3_bucket_ownership_controls" "Lambda_Bucket_Ownership_Controls" {
  bucket = aws_s3_bucket.lambda_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}