resource "aws_instance" "jenkins_server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.vpc_security_group_id]
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile

  user_data = templatefile("${path.module}/user_data.sh", {
    jenkins_admin_user     = var.jenkins_admin_user
    jenkins_admin_password = var.jenkins_admin_password
  })

  tags = {
    Name = "Terraform-Jenkins-Server"
  }
}

output "public_ip" {
  value = aws_instance.jenkins_server.public_ip
}
