// Generating SSH keys in `/Users/bhavyasachdeva/Desktop/zenskar-assignment/terraform/module/ssh/generated_key.pem`

provider "tls" {}

resource "tls_private_key" "ngx_example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ngx_generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ngx_example.public_key_openssh
}

resource "local_file" "private_key" {
  content          = tls_private_key.ngx_example.private_key_pem
  filename         = "${path.module}/ngx_generated_key.pem"
  file_permission  = "0400"
}

resource "null_resource" "ngx_generate_public_key" {
  provisioner "local-exec" {
    command = "ssh-keygen -y -f ${path.module}/ngx_generated_key.pem > ${path.module}/ngx_generated_key.pem.pub"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [local_file.private_key]
}
