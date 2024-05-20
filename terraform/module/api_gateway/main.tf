# Create API Gateway for NGINX
resource "aws_apigatewayv2_api" "ngx_api" {
  name          = "ngx-api"
  protocol_type = "HTTP"
  description   = "API Gateway for Nginx Load Balancer"
  tags = {
    Name = "NginxAPI"
  }
}

# Integrate API with NGINX ALB
resource "aws_apigatewayv2_integration" "nginx_integration" {
  api_id             = aws_apigatewayv2_api.ngx_api.id
  integration_type   = "HTTP_PROXY"
  integration_method = "GET"
  integration_uri    = "http://${var.alb_dns_name}"
  description        = "Integration with Nginx ALB"
}

# Define API route for GET requests
resource "aws_apigatewayv2_route" "nginx_route" {
  api_id    = aws_apigatewayv2_api.ngx_api.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.nginx_integration.id}"
}

# Configure default API stage
resource "aws_apigatewayv2_stage" "nginx_stage" {
  api_id        = aws_apigatewayv2_api.ngx_api.id
  name          = "default"
  auto_deploy   = true
  default_route_settings {
    throttling_burst_limit = 10
    throttling_rate_limit  = 5
    detailed_metrics_enabled = true
  }
  description = "Default stage for Nginx API"
}
