provider "aws" {
  region = "us-east-1"
}

# Define a API Gateway v2
resource "aws_apigatewayv2_api" "api" {
  name          = "MyAPI"
  protocol_type = "HTTP"
}

# Define a função Lambda
resource "aws_lambda_function" "lambda" {
  function_name = "my_lambda_function"
  handler       = "index.handler"
  runtime       = "python3.9"

  # Código da Lambda
  filename = "lambda_function_payload.zip"
  
  role = aws_iam_role.lambda_exec.arn
}

# Define a role para a função Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# Permissão para o API Gateway invocar a função Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*"
}

# Define a integração entre o API Gateway e a função Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.lambda.invoke_arn
  integration_method = "POST"
}

# Define a rota para o API Gateway
resource "aws_apigatewayv2_route" "clientes_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /clientes"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Define o stage para o API Gateway
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

