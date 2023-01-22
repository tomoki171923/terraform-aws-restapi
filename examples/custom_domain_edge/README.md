# Complete Custom Domain REST API (Edge Optimized)

Configuration in this directory creates Custom Domain RestAPI invoking lambda function on Amazon API Gateway.

## Usage

To run this example you need to execute:

```bash
terraform init
terraform plan
terraform apply
```

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= 1.0  |
| aws       | ~> 4.11 |

## Providers

| Name | Version |
| ---- | ------- |
| aws  | ~> 4.11 |

## Inputs

| Name                     | Description                                                                                                                                                                                                                                                                                                                                | Type                                                                                                                                                      | Default                                                                                                                                                                                                                                                                                                                         | Required |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------: |
| api_name                 | The REST API's name on Amazon API Gateway                                                                                                                                                                                                                                                                                                  | `string` | `""` |   yes    |
| endpoint_type            | The REST API's endpoint type on Amazon API Gateway                                                                                                                                                                                                                                                                                         | `string` | `"REGIONAL"` |    no    |
| methods                  | REST API's methods. name: api method name, path: api method path, lambda_function_name: aws lambda function name.                                                                                                                                                                                                                          | <pre>list(object({<br> name = string<br> path = string<br> lambda_function_name = string<br>}))</pre>                                                     | `[]` |   yes    |
| stages                   | REST API's stages. name: stage name, description: deployment description, logging_level: cloudwatch logging level, log_retention: cloudwatch log retention in days.                                                                                                                                                                                                                 | <pre>list(object({<br> name = string<br> description = string<br> logging_level = string<br> log_retention = number<br>}))</pre>                                                     | <pre>[<br> {<br> name = "dev", <br> description = "development deployment", <br> log_retention = "INFO", <br> log_retention = 7, <br> }, <br> {<br> name = "st", <br> description = "staging deployment", <br> log_retention = "INFO", <br> log_retention = 30, <br> }, <br> {<br> name = "pro", <br> description = "production deployment", <br> log_retention = "INFO", <br> log_retention = 60, <br> }, <br>]</pre> |    no    |
| stage_name               | The target stage name to update.                                                                                                                                                                                                                                                                                                           | `string` | `""` |   yes    |
| oas30                    | OpenAPI 3 + API Gateway Extensions (JSON syntax)                                                                                                                                                                                                                                                                                           | `string` | `""` |   yes    |
| custom_domain_names_edge | Custom Domain Names (Edge Optimized with ACM Certificate). zone_id: Hosted zone ID, domain_name: custom domain name, certificate_arn: acm certificate arn, stage_name: Name of a specific deployment stage to expose at the given path, base_path: Path segment that must be prepended to the path when accessing the API via this mappin. | <pre>list(object({<br> zone_id = string<br> domain_name = string<br> certificate_arn = string<br> stage_name = string<br> base_path = string<br>}))</pre> | `null` |    no    |

## Outputs

| Name               | Description                                                                                                                                                               |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| rest_api           | REST API's Attributes. See [official](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api#attributes-reference) for details. |
| deployments        | Attributes of deployments. See [official](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) for details.                |
| stages             | Attributes of stages. See [official](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) for details.                          |
| methods            | Attributes of API Methods. See [official](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) for details.           |
| lambda_permissions | Attributes of Lambda Permission. See [official](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) for details.               |
| log_groups         | Attributes of CloudWatch LogGroups. See [official](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) for details.         |
| custom_domain_edge         | Attributes of Custom domain settings. See [api_gateway_domain_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name), [aws_api_gateway_base_path_mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) and [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) for details.        |

## Authors

Module managed by [tomoki171923](https://github.com/tomoki171923).

## License

MIT Licensed. See LICENSE for full details.
