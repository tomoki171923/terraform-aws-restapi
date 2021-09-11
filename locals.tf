locals {
  stages = {
    dev = {
      deployment_id         = aws_api_gateway_deployment.dev.id
      log_retention_in_days = var.log_retention_in_days.dev
    }
    st = {
      deployment_id         = aws_api_gateway_deployment.st.id
      log_retention_in_days = var.log_retention_in_days.st
    }
    pro = {
      deployment_id         = aws_api_gateway_deployment.pro.id
      log_retention_in_days = var.log_retention_in_days.pro
    }
  }
}
