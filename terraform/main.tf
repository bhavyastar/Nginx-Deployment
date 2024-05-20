module "vpc_ngx" {
  source = "./module/vpc"
}

module "ssh" {
  source = "./module/ssh"
  key_name = "test"
}

module "ec2" {
  source = "./module/ec2"
  key_name = module.ssh.key_name
  vpc_id = module.vpc_ngx.vpc_id
  private_subnet_id = module.vpc_ngx.private_subnet_ids[0]
  public_subnet_id = module.vpc_ngx.public_subnet_ids[0]
  private_key_path = "<private-key-path>"
  alb_security_group_id = module.vpc_ngx.alb_security_group_id
}

module "nginx_lb" {
  source               =  "./module/alb"
  public_subnets  =  module.vpc_ngx.public_subnet_ids
  alb_security_group_id = module.vpc_ngx.alb_security_group_id 
  vpc_id               = module.vpc_ngx.vpc_id
  instance_ids         = module.ec2.private_instance_ids
}

module "api_gateway" {
  source      = "./module/api_gateway"
  alb_dns_name = module.nginx_lb.alb_dns_name
}

