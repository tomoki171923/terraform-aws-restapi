output "rest_api" {
  value = aws_api_gateway_rest_api.this
}
output "deployments" {
  value = aws_api_gateway_deployment.this
}
output "stages" {
  value = aws_api_gateway_stage.this
}
output "lambda_permissions" {
  value = aws_lambda_permission.this
}
output "methods" {
  value = aws_api_gateway_method_settings.this
}
output "log_groups" {
  value = aws_cloudwatch_log_group.this
}
output "custom_domain_edge" {
  value = module.custom_domain_edge
}
