variable "api_name" {
  description = "rest api name on aws apigateway"
  type        = string
  default     = null
}
variable "method_name" {
  description = "api method name like GET, PUT, POST, DELETE and so on."
  type        = string
  default     = null
}
variable "method_path" {
  description = "api method path"
  type        = string
  default     = null
}
variable "lambda_function_name" {
  description = "aws lambda function name"
  type        = string
  default     = null
}
variable "lambda_function_arn" {
  description = "aws lambda function arn"
  type        = string
  default     = null
}
variable "stage_name" {
  description = "stage name on this rest api to deploy"
  type        = string
  default     = null
  validation {
    condition     = var.stage_name == "dev" || var.stage_name == "st" || var.stage_name == "pro"
    error_message = "Please input an environment just between [dev, st ,pro]."
  }
}
variable "oas30" {
  description = "OpenAPI 3 + API Gateway Extensions (JSON syntax)"
  type        = string
  default     = null
}
variable "log_retention_in_days_dev" {
  description = "cloudwatch log retention in days for development stage."
  type = number
  default = 7
}
variable "log_retention_in_days_st" {
  description = "cloudwatch log retention in days for staging stage."
  type = number
  default = 7
}
variable "log_retention_in_days_pro" {
  description = "cloudwatch log retention in days for production stage."
  type = number
  default = 30
}