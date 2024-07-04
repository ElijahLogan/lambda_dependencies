output "api_id" {
  value = aws_api_gateway_rest_api.my_api.id
}

output "root_resource_id" {
  value =  aws_api_gateway_resource.root.id
}

output "get_data_http" {
  value = aws_api_gateway_method.get_data.http_method
}


output "test_execution_arn" {
  value = aws_api_gateway_rest_api.my_api.execution_arn
}



 
