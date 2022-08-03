data "archive_file" "lambda_source" {
  type        = "zip"
  source_dir  = "${path.module}/src/"
  output_path = "${path.module}/${var.function_name}.zip"
}

resource "aws_iam_role" "iam_role_lambda" {
  name                 = "${var.account_id}-${var.function_name}-iam_role_lambda"
  permissions_boundary = "arn:aws:iam::${var.account_id}:policy/tlz_permission_boundaries"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda" {
  role             = aws_iam_role.iam_role_lambda.arn
  runtime          = "python3.8"
  function_name    = var.function_name
  handler          = "${var.function_name}.lambda_handler"
  filename         = data.archive_file.lambda_source.output_path
  source_code_hash = data.archive_file.lambda_source.output_base64sha256
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.apigw_rest_api.execution_arn}/*/*"
}
