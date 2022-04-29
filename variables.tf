variable "api_name" {
  description = "rest api name on aws apigateway"
  type        = string
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
  description = "name: stage name, description: deployment description, log_retention: cloudwatch log retention in days."
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
      log_retention = 7,
    },
    {
      name          = "st",
      description   = "staging deployment",
      log_retention = 30,
    },
    {
      name          = "pro",
      description   = "production deployment",
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
