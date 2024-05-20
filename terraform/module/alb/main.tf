# Resource: AWS Application Load Balancer (ALB)


resource "aws_lb" "nginx_lb" {
  name               = "nginx-lb"
  internal           = false 
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnets

  tags = {
    Name = "nginx-load-balancer"
  }
}


# Resource: Target Group for NGINX


resource "aws_lb_target_group" "nginx_target_group" {
  name     = "nginx-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

# Health checks to ensure registered targets are healthy and able to receive traffic

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "nginx-target-group"
  }
}

# Resource: Listener for the Application Load Balancer

resource "aws_lb_listener" "front_end_listener" {
  load_balancer_arn = aws_lb.nginx_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
}

# Resource: Attach EC2 Instances to the Target Group

resource "aws_lb_target_group_attachment" "tg_attachment" {
  count            = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.nginx_target_group.arn
  target_id        = element(var.instance_ids, count.index)
  port             = 80
}

