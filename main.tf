provider "aws" {
  region = "us-east-1"
}

# Define uma API Gateway v2
resource "aws_apigatewayv2_api" "api" {
  name          = "gtw-mducati"
  protocol_type = "HTTP"
}

# Referencia funções Lambda existentes
data "aws_lambda_function" "cadastrar_cliente_lambda" {
  function_name = "lambda-compradores-CadastrarClienteFunction"
}

data "aws_lambda_function" "criar_veiculo_lambda" {
  function_name = "CriarVeiculoFunction"
}

data "aws_lambda_function" "editar_veiculo_lambda" {
  function_name = "EditarVeiculoFunction"
}

data "aws_lambda_function" "listar_disponiveis_lambda" {
  function_name = "ListarVeiculosDisponiveisFunction"
}

data "aws_lambda_function" "listar_vendidos_lambda" {
  function_name = "ListarVeiculosVendidosFunction"
}

data "aws_lambda_function" "reservar_veiculo_lambda" {
  function_name = "ReservarVeiculoFunction"
}

data "aws_lambda_function" "processar_pagamento_lambda" {
  function_name = "ProcessarPagamentoFunction"
}

# Define a role para a função Lambda
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

# Permissão para o API Gateway invocar as funções Lambda
resource "aws_lambda_permission" "apigw_lambda_cadastrar_cliente" {
  statement_id  = "AllowAPIGatewayInvoke-${uuid()}"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.cadastrar_cliente_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_lambda_criar_veiculo" {
  statement_id  = "AllowAPIGatewayInvoke-${uuid()}"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.criar_veiculo_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_lambda_editar_veiculo" {
  statement_id  = "AllowAPIGatewayInvoke-${uuid()}"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.editar_veiculo_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_lambda_listar_disponiveis" {
  statement_id  = "AllowAPIGatewayInvoke-${uuid()}"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.listar_disponiveis_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_lambda_listar_vendidos" {
  statement_id  = "AllowAPIGatewayInvoke-${uuid()}"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.listar_vendidos_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_lambda_reservar_veiculo" {
  statement_id  = "AllowAPIGatewayInvoke-${uuid()}"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.reservar_veiculo_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_lambda_processar_pagamento" {
  statement_id  = "AllowAPIGatewayInvoke-${uuid()}"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.processar_pagamento_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

# Define a integração entre o API Gateway e as funções Lambda
resource "aws_apigatewayv2_integration" "lambda_integration_cadastrar_cliente" {
  api_id                = aws_apigatewayv2_api.api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = data.aws_lambda_function.cadastrar_cliente_lambda.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "lambda_integration_criar_veiculo" {
  api_id                = aws_apigatewayv2_api.api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = data.aws_lambda_function.criar_veiculo_lambda.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "lambda_integration_editar_veiculo" {
  api_id                = aws_apigatewayv2_api.api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = data.aws_lambda_function.editar_veiculo_lambda.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "lambda_integration_listar_disponiveis" {
  api_id                = aws_apigatewayv2_api.api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = data.aws_lambda_function.listar_disponiveis_lambda.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "lambda_integration_listar_vendidos" {
  api_id                = aws_apigatewayv2_api.api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = data.aws_lambda_function.listar_vendidos_lambda.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "lambda_integration_reservar_veiculo" {
  api_id                = aws_apigatewayv2_api.api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = data.aws_lambda_function.reservar_veiculo_lambda.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "lambda_integration_processar_pagamento" {
  api_id                = aws_apigatewayv2_api.api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = data.aws_lambda_function.processar_pagamento_lambda.invoke_arn
  payload_format_version = "2.0"
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

# Define as rotas com autorização JWT
resource "aws_apigatewayv2_route" "clientes_route_with_auth" {
  api_id            = aws_apigatewayv2_api.api.id
  route_key         = "POST /clientes"
  target            = "integrations/${aws_apigatewayv2_integration.lambda_integration_cadastrar_cliente.id}"
  authorization_type = "JWT"
  authorizer_id     = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

resource "aws_apigatewayv2_route" "criar_veiculo_route_with_auth" {
  api_id            = aws_apigatewayv2_api.api.id
  route_key         = "POST /veiculos"
  target            = "integrations/${aws_apigatewayv2_integration.lambda_integration_criar_veiculo.id}"
  authorization_type = "JWT"
  authorizer_id     = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

resource "aws_apigatewayv2_route" "editar_veiculo_route_with_auth" {
  api_id            = aws_apigatewayv2_api.api.id
  route_key         = "PUT /veiculos/{id}"
  target            = "integrations/${aws_apigatewayv2_integration.lambda_integration_editar_veiculo.id}"
  authorization_type = "JWT"
  authorizer_id     = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

resource "aws_apigatewayv2_route" "listar_disponiveis_route" {
  api_id            = aws_apigatewayv2_api.api.id
  route_key         = "GET /veiculos/disponiveis"
  target            = "integrations/${aws_apigatewayv2_integration.lambda_integration_listar_disponiveis.id}"
}

resource "aws_apigatewayv2_route" "listar_vendidos_route" {
  api_id            = aws_apigatewayv2_api.api.id
  route_key         = "GET /veiculos/vendidos"
  target            = "integrations/${aws_apigatewayv2_integration.lambda_integration_listar_vendidos.id}"
}

resource "aws_apigatewayv2_route" "reservar_veiculo_route_with_auth" {
  api_id            = aws_apigatewayv2_api.api.id
  route_key         = "POST /veiculos/{id}/reservar"
  target            = "integrations/${aws_apigatewayv2_integration.lambda_integration_reservar_veiculo.id}"
  authorization_type = "JWT"
  authorizer_id     = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

resource "aws_apigatewayv2_route" "processar_pagamento_route_with_auth" {
  api_id            = aws_apigatewayv2_api.api.id
  route_key         = "POST /pagamentos"
  target            = "integrations/${aws_apigatewayv2_integration.lambda_integration_processar_pagamento.id}"
  authorization_type = "JWT"
  authorizer_id     = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

# Define o deployment da API
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "dev"
  auto_deploy = true
}
