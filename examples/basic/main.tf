provider "aws" {
  region = "ap-northeast-1"
}

module "rest_api" {
  source   = "../../"
  api_name = "sample"
  methods = [
    {
      name                 = "PUT"
      path                 = "put-item"
      lambda_function_name = "put_item"
    }
  ]
  stage_name = var.environment
  oas30 = templatefile("./sample-oas30-apigateway.yaml",
    {
      integration_url = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${data.aws_lambda_function.this.arn}:$${stageVariables.LambdaAlias}/invocations"
    }
  )
  is_first_deploy = true
}

data "aws_region" "current" {}
data "aws_lambda_function" "this" {
  function_name = "put_item"
}
