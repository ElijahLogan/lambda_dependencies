resource "aws_s3_bucket" "depend_bucket" {
  bucket = "eli-depend-bucket"
}


locals {
  zip_file = "/tmp/some_zip.zip"
}

resource "null_resource" "pip_install" {

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/create_pkg.sh"
    
   environment = {
      source_code_path = "lambda_function"
      function_name = "aws_lambda_test"
      path_module = path.module
      runtime = "python3.9"
      path_cwd = path.cwd
    }
}
}

data "archive_file" "create_dist_pkg" {
  depends_on = ["null_resource.pip_install"]
  source_dir = "${path.cwd}/lambda_dist_pkg/"
  output_path = local.zip_file
  type = "zip"
}
resource "local_file" "lambda_python_code" {
  content  = file("${path.module}/test.py")
  filename = "${path.module}/lambda_dist_pkg/lambda_function.py"
}
# data "archive_file" "code" {
#   type        = "zip"
#   source_dir  = "${path.module}/code"
#   output_path = "${path.module}/code.zip"
# }


# data "archive_file" "layer" {
#   type        = "zip"
#   source_dir  = "${path.module}/layer"
#   output_path = "${path.module}/layer.zip"
#   depends_on  = [null_resource.pip_install]
# }

# resource "aws_s3_object" "object_load" {
#   bucket = aws_s3_bucket.depend_bucket.id
#   key    = "layer.zip"
#   source = "${path.module}/layer.zip"

#   depends_on = [
#   aws_s3_bucket.depend_bucket
#   ]
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
# }

resource "aws_iam_role" "panda_role" {
  name = "pandas_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}


# resource "aws_lambda_layer_version" "layer" {
#   layer_name          = "test-layer"
#   filename            = "${path.module}/layer.zip"
#   source_code_hash = data.archive_file.code.output_base64sha256
#   compatible_runtimes = ["python3.9", "python3.8", "python3.7", "python3.6"]
#   depends_on = [
#     data.archive_file.code
#   ]
# }




resource "aws_lambda_function" "test_lam"{
  function_name    = "lambda_function"
  handler          = "test.handler"
  runtime          = "python3.9"
  depends_on = [null_resource.pip_install]
  source_code_hash = data.archive_file.create_dist_pkg.output_base64sha256
  filename = data.archive_file.create_dist_pkg.output_path
  role             = aws_iam_role.panda_role.arn
  # layers           = [aws_lambda_layer_version.layer.arn]
  environment {
    variables = {
      "MESSAGE" = "Terraform sends its regards"
    }
  
  }
}




