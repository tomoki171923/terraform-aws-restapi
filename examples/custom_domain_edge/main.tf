provider "aws" {
  region = "ap-northeast-1"
}

module "rest_api" {
  source        = "../../"
  api_name      = "sample"
  endpoint_type = "EDGE"
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
  custom_domain_names_edge = [
    {
      zone_id         = data.aws_route53_zone.this.zone_id
      domain_name     = "api.sample.com"
      certificate_arn = data.aws_acm_certificate.pro.arn
      stage_name      = "pro"
      base_path       = null
    },
    {
      zone_id         = data.aws_route53_zone.this.zone_id
      domain_name     = "api.st.sample.com"
      certificate_arn = data.aws_acm_certificate.st.arn
      stage_name      = "st"
      base_path       = null
    },
    {
      zone_id         = data.aws_route53_zone.this.zone_id
      domain_name     = "api.dev.sample.com"
      certificate_arn = data.aws_acm_certificate.dev.arn
      stage_name      = "dev"
      base_path       = null
    },
  ]
  is_first_deploy = true
}

data "aws_region" "current" {}
data "aws_lambda_function" "this" {
  function_name = "put_item"
}
/*
  acm state
*/
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
data "aws_acm_certificate" "pro" {
  provider    = aws.virginia
  domain      = "*.sample.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
data "aws_acm_certificate" "st" {
  provider    = aws.virginia
  domain      = "*.st.sample.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
data "aws_acm_certificate" "dev" {
  provider    = aws.virginia
  domain      = "*.dev.sample.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

/*
  route53 state
*/
data "aws_route53_zone" "this" {
  name = "sample.com"
}
