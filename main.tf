# ********************************* #
# REST API on API Gateway
# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
#      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage
#      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission
#      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings
#      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
# ********************************* #

/*
  restapi
*/
locals {
  rest_api_state = data.aws_api_gateway_rest_api.this
  deploy_flag    = local.rest_api_state == [] ? { for s in var.stages : "deploy_flag_${s.name}" => true } : { for s in var.stages : "deploy_flag_${s.name}" => var.stage_name == s.name ? !local.rest_api_state[0].tags["deploy_flag_${s.name}"] : local.rest_api_state[0].tags["deploy_flag_${s.name}"] }
  tags = {
    Terraform = true
    API       = var.api_name
  }
}
resource "aws_api_gateway_rest_api" "this" {
  name = var.api_name
  endpoint_configuration {
    types = [var.endpoint_type]
  }
  body = var.oas30
  tags = merge(local.tags, local.deploy_flag)
}

/*
  deployments
*/
data "aws_api_gateway_rest_api" "this" {
  count = var.is_first_deploy == true ? 0 : 1
  name  = var.api_name
}
resource "aws_api_gateway_deployment" "this" {
  for_each = {
    for key in var.stages : key.name => {
      description = key.description
    }
  }
  rest_api_id = aws_api_gateway_rest_api.this.id
  description = each.value.description
  triggers = {
    # redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
    redeployment = aws_api_gateway_rest_api.this.tags["deploy_flag_${each.key}"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

/*
  stages
*/
resource "aws_api_gateway_stage" "this" {
  for_each = {
    for key in var.stages : key.name => {
      name        = key.name
      description = key.description
    }
  }
  deployment_id = aws_api_gateway_deployment.this[each.value.name].id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = each.value.name
  variables = {
    LambdaAlias = each.value.name
  }
}

/*
  lambda permissions
*/
locals {
  lambda_permissions = flatten([
    for stage in var.stages : [
      for method in var.methods : {
        id                   = "${method.lambda_function_name}_${stage.name}"
        stage_name           = stage.name
        method_name          = method.name
        method_path          = method.path
        lambda_function_name = method.lambda_function_name
      }
    ]
  ])
}
resource "aws_lambda_permission" "this" {
  for_each = {
    for key in local.lambda_permissions : key.id => {
      id                   = key.id
      stage_name           = key.stage_name
      method_name          = key.method_name
      method_path          = key.method_path
      lambda_function_name = key.lambda_function_name
    }
  }
  statement_id  = "allow_${aws_api_gateway_rest_api.this.name}_api_to_invoke_${each.value.id}"
  action        = "lambda:InvokeFunction"
  function_name = "${each.value.lambda_function_name}:${each.value.stage_name}" # need the stage variable in the function name parameter.
  qualifier     = each.value.stage_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/${each.value.method_name}/${each.value.method_path}"
  depends_on = [
    aws_api_gateway_stage.this
  ]
  lifecycle {
    ignore_changes = [
      # Ignore changes to statement_id because it always changes to (known after apply).
      function_name,
      statement_id,
    ]
  }
}

/*
  cloudwatch logs
*/
resource "aws_api_gateway_method_settings" "this" {
  for_each = {
    for s in var.stages : s.name => {
      logging_level = s.logging_level
    }
  }
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = each.key
  method_path = "*/*"
  settings {
    metrics_enabled = false
    logging_level   = each.value.logging_level
  }
  depends_on = [aws_cloudwatch_log_group.this, aws_api_gateway_stage.this]
}
resource "aws_cloudwatch_log_group" "this" {
  for_each = {
    for s in var.stages : s.name => {
      name          = s.name
      log_retention = s.log_retention
    }
  }
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.this.id}/${each.value.name}"
  retention_in_days = each.value.log_retention
  tags              = merge(local.tags, { Stage = each.value.name })
}

/*
  custom domain name
*/
module "custom_domain_edge" {
  count               = var.custom_domain_names_edge == null ? 0 : 1
  source              = "./modules/custom_domain_edge"
  rest_api_id         = aws_api_gateway_rest_api.this.id
  custom_domain_names = var.custom_domain_names_edge
  tags                = local.tags
}

/*
  custom domain name
*/
module "custom_domain_edge" {
  count               = var.custom_domain_names_edge == null ? 0 : 1
  source              = "./modules/custom_domain_edge"
  rest_api_id         = aws_api_gateway_rest_api.this.id
  custom_domain_names = var.custom_domain_names_edge
  tags                = local.tags
}
