
module lambda {
    source = "./modules/lambda"
}
module api {
    source = "./modules/api"
    test_lambda_invoke_arn = module.lambda.test_lambda_invoke_arn
}



# module integration{
#     source = "./modules/integration"
#     api_id  = module.api.api_id
#     root_resource_id = module.api.root_resource_id
#     get_data_http = module.api.get_data_http
#     test_lambda_invoke_arn = module.lambda.test_lambda_invoke_arn
# }


module iam{
    source = "./modules/iam" 
    test_function_name = module.lambda.test_function_name
    test_execution_arn = module.api.test_execution_arn
    role_name = module.lambda.role_name
}