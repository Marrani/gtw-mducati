output "api_endpoint" {
  description = "URL do API Gateway"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}
