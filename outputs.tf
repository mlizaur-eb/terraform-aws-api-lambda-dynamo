

output "base_url" {
  value = "${aws_api_gateway_deployment.v3_lambda_spike_api_deployment.invoke_url}"
}
