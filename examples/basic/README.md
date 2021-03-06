# Complete Simple REST API

Configuration in this directory creates simple RestAPI invoking lambda function on Amazon API Gateway.

## Usage

To run this example you need to execute:

```bash
terraform init
terraform plan
terraform apply
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 4.11 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 4.11 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api\_name | The REST API's name on Amazon API Gateway | `string` | `""` | yes |
| methods | REST API's methods. name: api method name, path: api method path, lambda_function_name: aws lambda function name. | <pre>list(object({<br>    name                 = string<br>    path                 = string<br>    lambda_function_name = string<br>}))</pre> | `[]` | yes |
| stages | REST API's stages. name: stage name, description: deployment description, log_retention: cloudwatch log retention in days. | <pre>list(object({<br>    name          = string<br>    description   = string<br>    log_retention = number<br>}))</pre> |<pre>[<br>  {<br>    name          = "dev", <br>    description   = "development deployment", <br>    log_retention = 7, <br>  }, <br>  {<br>    name          = "st", <br>    description   = "staging deployment", <br>    log_retention = 30, <br>  }, <br>  {<br>    name          = "pro", <br>    description   = "production deployment", <br>    log_retention = 60, <br>  }, <br>]</pre>| no |
| stage\_name | The target stage name to update. | `string` | `""` | yes |
| oas30 | OpenAPI 3 + API Gateway Extensions (JSON syntax) | `string` | `""` | yes |

## Outputs

| Name | Description |
|------|-------------|
| rest_api | REST API's Attributes. See [official](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api#attributes-reference) for details. |
| deployments | Attributes of deployments. See [official](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) for details. |
| stages | Attributes of stages. See [official](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) for details. |
| methods | Attributes of API Methods. See [official](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) for details. |
| lambda_permissions | Attributes of Lambda Permission. See [official](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) for details. |
| log_groups | Attributes of CloudWatch LogGroups. See [official](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) for details. |

## Authors

Module managed by [tomoki171923](https://github.com/tomoki171923).

## License

MIT Licensed. See LICENSE for full details.
