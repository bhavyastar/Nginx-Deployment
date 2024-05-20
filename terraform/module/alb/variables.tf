variable "public_subnets"{
  description = "The subnets where the load balancer will be located."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "The security group ID to assign to the load balancer."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the target groups and ALB are created."
  type        = string
}

variable "instance_ids" {
  description = "List of EC2 instance IDs to attach to the load balancer."
  type        = list(string)
}