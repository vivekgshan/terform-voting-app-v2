provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./network"
  vpc_id = var.vpc_id
  subnet_id = var.subnet_id
}

module "iam" {
  source = "./iam"
}

module "jenkins" {
  source               = "./jenkins"
  subnet_id            = var.subnet_id
  vpc_security_group_id = module.network.jenkins_sg_id
  iam_instance_profile  = module.iam.ec2_instance_profile
  ami                   = var.ami
  instance_type         = var.instance_type
  key_name              = var.key_name
  jenkins_admin_user    = var.jenkins_admin_user
  jenkins_admin_password = var.jenkins_admin_password
}
