output "vpc_id" {
  value       = aws_vpc.vpc_ngx.id
  description = "The ID of the VPC created."
}

output "public_subnet_ids" {
  value       = aws_subnet.ngx_public_subnet.*.id
  description = "IDs of the public subnets created."
}

output "public_subnet_azs" {
  value = { for s in aws_subnet.ngx_public_subnet : s.id => s.availability_zone }
  description = "Availability Zones of the public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.ngx_private_subnet.*.id
  description = "IDs of the private subnets created."
}

output "private_subnet_azs" {
  value = { for s in aws_subnet.ngx_private_subnet : s.id => s.availability_zone }
  description = "Availability Zones of the private subnets"
}

output "nat_gateway_ids" {
  value       = aws_nat_gateway.ngx_nat.*.id
  description = "IDs of the NAT Gateways created."
}

output "public_route_table_id" {
  value       = aws_route_table.ngx_public_rt.id
  description = "ID of the public route table."
}

output "private_route_table_ids" {
  value       = aws_route_table.ngx_private_rt.*.id
  description = "IDs of the private route tables."
}

output "alb_security_group_id" {
  value = aws_security_group.ngx_alb_sg.id
  description = "The ID of the security group used by the ALB"
}
