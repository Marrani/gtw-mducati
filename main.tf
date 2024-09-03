provider "aws" {
  region = "us-east-1"
}

resource "aws_apigatewayv2_api" "http_api" {
  name          = "gtw-mducati"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_authorizer" "jwt_authorizer" {
  api_id   = aws_apigatewayv2_api.http_api.id
  name     = "teste"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = ["550nrvhdi1rs6dpnluakmi1mdh"]
    issuer   = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_WhT5Isndg"
  }

  authorizer_type = "JWT"
}

resource "aws_lambda_permission" "api_gateway_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-1:360478535176:function:lambda-compradores-CadastrarClienteFunction"
  principal     = "apigateway.amazonaws.com"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:360478535176:function:lambda-compradores-CadastrarClienteFunction-amp3BkCEiwfI/invocations"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "clientes_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /clientes"
  target    = aws_apigatewayv2_integration.lambda_integration.id
  authorizer_id = aws_apigatewayv2_authorizer.jwt_authorizer.id
}

resource "aws_apigatewayv2_stage" "prod_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "prod"
  auto_deploy = true
}

output "api_endpoint" {
  description = "URL do API Gateway"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}
