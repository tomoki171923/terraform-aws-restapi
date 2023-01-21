variable "rest_api_id" {
  description = "rest api id on aws apigateway"
  type        = string
}
variable "custom_domain_names" {
  description = "zone_id: Hosted zone ID, domain_name: custom domain name, certificate_arn: acm certificate arn, stage_name: Name of a specific deployment stage to expose at the given path, base_path: Path segment that must be prepended to the path when accessing the API via this mappin."
  type = list(
    object({
      zone_id         = string
      domain_name     = string
      certificate_arn = string
      stage_name      = string
      base_path       = string
    })
  )
}
variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
