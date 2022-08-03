resource "aws_api_gateway_rest_api" "apigw" {
  name = "apigw"
}

resource "aws_api_gateway_resource" "apigw_resource" {
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "apigw_method" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.apigw_resource.id
  http_method = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "apigw_integration" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.apigw_resource.id
  http_method             = aws_api_gateway_method.apigw_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "apigw_deployment" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  depends_on = [
    aws_api_gateway_integration.apigw_integration
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "apigw_stage" {
  deployment_id = aws_api_gateway_deployment.apigw_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  stage_name    = "test"
}