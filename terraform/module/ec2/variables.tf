variable "ami_id" {
  description = "The AMI ID for the EC2 instances."
  type        = string
  default = "ami-0bb84b8ffd87024d8"
}

variable "instance_type" {
  description = "The type of EC2 instance to create."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key name of the AWS Key Pair to attach to the instances."
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet where the jump host will be placed."
  type        = string
}

variable "private_subnet_id" {
  description = "The ID of the private subnet where the private instances will be placed."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the security groups will be created."
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key file for SSH access"
  type        = string
}

variable "instance_user" {
  description = "The username for SSH access to the instance"
  default     = "ec2-user"  # Change as per your AMI's default user
}

variable "alb_security_group_id" {
  description = "The security group ID of the ALB"
  type        = string
}

