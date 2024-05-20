output "public_ip" {
  value = aws_instance.ngx_public_instance.public_ip
}

output "private_ips" {
  value = aws_instance.ngx_private_instance[*].private_ip
}

output "public_instance_id" {
  value = aws_instance.ngx_public_instance.id
  description = "ID of the public EC2 instance"
}

output "private_instance_ids" {
  value = [for instance in aws_instance.ngx_private_instance : instance.id]
  description = "IDs of the private EC2 instances"
}

