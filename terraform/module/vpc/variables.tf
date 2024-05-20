variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/17"  // Supports 32,768 IPs
}

variable "availability_zones" {
  description = "A list of availability zones in the region."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]  
}

