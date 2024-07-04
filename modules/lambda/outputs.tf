output "test_lambda_invoke_arn" {
  value = aws_lambda_function.test_lam.invoke_arn
}

output "role_name" {
  value = aws_iam_role.panda_role.name
}
output "test_function_name" {
  value = aws_lambda_function.test_lam.function_name
}
