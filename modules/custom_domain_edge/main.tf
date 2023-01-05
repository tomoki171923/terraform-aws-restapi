# ********************************* #
# API Gateway Custom Domain (Edge Optimized with ACM Certificate)
# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name
# ********************************* #

resource "aws_api_gateway_domain_name" "this" {
  for_each = {
    for key in var.custom_domain_names : key.domain_name => {
      domain_name     = key.domain_name
      certificate_arn = key.certificate_arn
    }
  }
  certificate_arn = each.value.certificate_arn
  domain_name     = each.value.domain_name
  tags            = var.tags
}

resource "aws_api_gateway_base_path_mapping" "this" {
  for_each = {
    for key in var.custom_domain_names : key.domain_name => {
      domain_name     = key.domain_name
      certificate_arn = key.certificate_arn
      stage_name      = key.stage_name
      base_path       = key.base_path
    }
  }
  api_id      = var.rest_api_id
  domain_name = each.value.domain_name
  stage_name  = each.value.stage_name
  base_path   = each.value.base_path
}

# DNS record using Route53.
resource "aws_route53_record" "this" {
  for_each = {
    for key in var.custom_domain_names : key.domain_name => {
      zone_id     = key.zone_id
      domain_name = key.domain_name
    }
  }
  name    = each.value.domain_name
  type    = "A"
  zone_id = each.value.zone_id
  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.this[each.value.domain_name].cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.this[each.value.domain_name].cloudfront_zone_id
  }
}
