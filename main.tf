provider "aws" {
  region = "us-east-1"
}

# Define uma API Gateway v2
resource "aws_apigatewayv2_api" "api" {
  name          = "gtw-mducati"
  protocol_type = "HTTP"
}

# Referencia uma função Lambda existente
data "aws_lambda_function" "existing_lambda" {
  function_name = "lambda-compradores-CadastrarClienteFunction"
}

# Role para a função Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

# Permissão para o API Gateway invocar a função Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke-${uuid()}"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.existing_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

# Define a integração entre o API Gateway e a função Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = data.aws_lambda_function.existing_lambda.invoke_arn
  payload_format_version = "2.0"
}

# Define uma rota para o API Gateway
resource "aws_apigatewayv2_route" "clientes_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /clientes"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Define um stage para o API Gateway
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

# Define um authorizer para o API Gateway
resource "aws_apigatewayv2_authorizer" "cognito_authorizer" {
  api_id            = aws_apigatewayv2_api.api.id
  authorizer_type   = "JWT"
  name              = "cognito_authorizer"
  jwt_configuration {
    audience = ["550nrvhdi1rs6dpnluakmi1mdh"]
    issuer   = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_WhT5Isndg"
  }
  identity_sources = ["$request.header.Authorization"]
}

# Atualiza a rota para usar o authorizer
resource "aws_apigatewayv2_route" "clientes_route_with_auth" {
  api_id            = aws_apigatewayv2_api.api.id
  route_key         = "POST /clientes"
  target            = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  authorization_type = "JWT"
  authorizer_id     = aws_apigatewayv2_authorizer.cognito_authorizer.id
}
