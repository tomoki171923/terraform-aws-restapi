variable "environment" {
  description = "Please input the environment to deploy between [dev, st, pro]. It is to be attached as apigateway stages."
  validation {
    condition     = var.environment == "dev" || var.environment == "st" || var.environment == "pro"
    error_message = "Please input an environment just between [dev, st ,pro]."
  }
}
