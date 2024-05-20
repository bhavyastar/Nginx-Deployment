# Define a public EC2 instance for external access, acts as a jump host 

resource "aws_instance" "ngx_public_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.zenskar_public_sg.id]

  tags = {
    Name = "public_jump_host"
  }
}

# Define private EC2 instances for internal services, not directly accessible from the internet.

resource "aws_instance" "ngx_private_instance" {
  count          = 2
  ami            = var.ami_id
  instance_type  = var.instance_type
  key_name       = var.key_name
  subnet_id      = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.zenskar_private_sg.id]

  tags = {
    Name = "private_instance ${count.index + 1}"
  }
}

# Security group for the public instance allowing SSH access from the internet.

resource "aws_security_group" "zenskar_public_sg" {
  name        = "zenskar-public-sg"
  description = "Security group for public instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for private instances, allowing SSH from the public instance and HTTP from the ALB.

resource "aws_security_group" "zenskar_private_sg" {
  name        = "zenskar-private-sg"
  description = "Security group for private instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.zenskar_public_sg.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Generates an Ansible inventory file and playbooklocally, listing the public and private IPs of created instances.

resource "local_file" "ansible_playbook_file" {
  // tpl file path (playbook)
  content = templatefile("<path-taken-from-home-directory>/zenskar-assignment/terraform/ansible/playbook.tpl", {
    public_ip       = aws_instance.ngx_public_instance.public_ip
  })
  filename = "<path-taken-from-home-directory>/zenskar-assignment/terraform/ansible/playbook.yml"
  depends_on = [aws_instance.ngx_public_instance]
}

resource "local_file" "ansible_inventory_file" {
    // tpl file path (inventory)
  content = templatefile("<path-taken-from-home-directory>/zenskar-assignment/terraform/ansible/inventory.tpl", {
    public_ip       = aws_instance.ngx_public_instance.public_ip
    private_ips     = [for instance in aws_instance.ngx_private_instance : instance.private_ip]
  })
  filename = "<path-taken-from-home-directory>/zenskar-assignment/terraform/ansible/inventory.ini"
  depends_on = [aws_instance.ngx_public_instance, aws_instance.ngx_private_instance]
}

resource "null_resource" "run_ansible" {
  depends_on = [
    local_file.ansible_inventory_file,
    local_file.ansible_playbook_file,
    aws_instance.ngx_public_instance,
    aws_instance.ngx_private_instance
  ]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ./ansible/inventory.ini ./ansible/playbook.yml"
  }
}
