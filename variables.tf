variable "api_name" {
  description = "rest api name on aws apigateway"
  type        = string
}
variable "endpoint_type" {
  description = "rest api endpoint type"
  type        = string
  default     = "REGIONAL"
}
variable "methods" {
  description = "name: api method name, path: api method path, lambda_function_name: aws lambda function name."
  type = list(
    object({
      name                 = string
      path                 = string
      lambda_function_name = string
    })
  )
}
variable "stages" {
  description = "name: stage name, description: deployment description, logging_level: cloudwatch logging level, log_retention: cloudwatch log retention in days."
  type = list(
    object({
      name          = string
      description   = string
      log_retention = number
    })
  )
  default = [
    {
      name          = "dev",
      description   = "development deployment",
      logging_level = "INFO",
      log_retention = 7,
    },
    {
      name          = "st",
      description   = "staging deployment",
      logging_level = "INFO",
      log_retention = 30,
    },
    {
      name          = "pro",
      description   = "production deployment",
      logging_level = "INFO",
      log_retention = 60,
    }
  ]
}
variable "stage_name" {
  description = "stage name on this rest api to deploy"
  type        = string
}
variable "oas30" {
  description = "OpenAPI 3 + API Gateway Extensions (JSON syntax)"
  type        = string
}
variable "is_first_deploy" {
  description = "whether this is the first deployment or not."
  type        = bool
}
variable "custom_domain_names_edge" {
  description = "custom domain names (Edge Optimized with ACM Certificate). zone_id: Hosted zone ID, domain_name: custom domain name, certificate_arn: acm certificate arn, stage_name: Name of a specific deployment stage to expose at the given path, base_path: Path segment that must be prepended to the path when accessing the API via this mappin."
  type = list(
    object({
      zone_id         = string
      domain_name     = string
      certificate_arn = string
      stage_name      = string
      base_path       = string
    })
  )
  default = null
}
