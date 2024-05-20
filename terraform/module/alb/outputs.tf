# Output: DNS Name of the Application Load Balancer (ALB)
# This output returns the DNS name of the ALB, which is crucial for accessing the load balancer externally, such as via a web browser or API calls.
output "alb_dns_name" {
  value       = aws_lb.nginx_lb.dns_name
  description = "The DNS name of the application load balancer."
}
