output "api_endpoint" {
  value = aws_apigatewayv2_api.ngx_api.api_endpoint
  description = "The endpoint for the Nginx application via API Gateway"
}