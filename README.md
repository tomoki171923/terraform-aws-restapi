<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [terraform-aws-restapi](#terraform-aws-restapi)
  - [For User](#for-user)
    - [Usage](#usage)
  - [For Contributor](#for-contributor)
    - [set pre-commit](#set-pre-commit)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# terraform-aws-restapi

Terraform module, which creates AWS apigateway restapi resources invoking lambda function.

## For User

### Usage

~~~
module "rest_api" {
  source               = "git::https://github.com/tomoki171923/terraform-apigateway-restapi.git"
  api_name             = "your_rest_api_name"
  method_name          = "GET"
  method_path          = "get-item"
  lambda_function_name = "your_lambda_function_name_to_invoke_from_api"
  lambda_function_arn  = "your_lambda_function_arn_to_invoke_from_api"
  stage_name           = "deploy_stage_name"
  oas30                = data.template_file.oas30-apigateway.rendered
}

data "template_file" "oas30-apigateway" {
  template = file("${path.module}/oas30-apigateway.yaml")
}
~~~

## For Contributor

### set pre-commit

~~~
brew install pre-commit
pre-commit install
~~~
