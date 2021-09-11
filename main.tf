# ********************************* #
# REST API on API Gateway
# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
#      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage
#      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission
#      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings
# ********************************* #

/*
    this api
*/

# restapi
resource "aws_api_gateway_rest_api" "this" {
  name = var.api_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  body = var.oas30
}


# deployment
# デプロイする際、再作成（delete&create）するので各stage毎に用意.
# developmentが1つだと、例えばdevのみ更新したい場合stagingやprodunctionが向いているdevelopmentを
# 削除することになる。
# TODO: 現状terraformではlifecycle内で変数が使えないので暫定対応としてoverride.tfで
# 指定したstage以外は更新しないようにしている。
# 個別でoverrideさせるため、for_each記法は行っていない。
resource "aws_api_gateway_deployment" "dev" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  description = "development deployment"
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [] # will be overrided.
  }
}
resource "aws_api_gateway_deployment" "st" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  description = "staging deployment"
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [] # will be overrided.
  }
}
resource "aws_api_gateway_deployment" "pro" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  description = "production deployment"
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [] # will be overrided.
  }
}


# stages
resource "aws_api_gateway_stage" "this" {
  for_each      = local.stages
  deployment_id = each.value.deployment_id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = each.key
  variables = {
    LambdaAlias = each.key
  }
}


# lambda permission
resource "aws_lambda_permission" "this" {
  for_each      = local.stages
  statement_id  = "allow_${aws_api_gateway_rest_api.this.name}_api_to_invoke_${var.lambda_function_name}_${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_name}:${each.key}"
  qualifier     = each.key
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/${var.method_name}/${var.method_path}"
  depends_on = [
    aws_api_gateway_stage.this
  ]
}


# cloudwatch log
resource "aws_api_gateway_method_settings" "this" {
  for_each    = local.stages
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = each.key
  method_path = "*/*"

  settings {
    metrics_enabled = false
    logging_level   = "INFO"
  }
}
resource "aws_cloudwatch_log_group" "this" {
  for_each          = local.stages
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.this.name}_${aws_api_gateway_rest_api.this.id}/${each.key}"
  retention_in_days = each.value.log_retention_in_days
}
