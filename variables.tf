variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_id" {}
variable "subnet_id" {}
variable "ami" {
  default = "ami-0c02fb55956c7d316"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "key_name" {
  default = "Jenkins"
}

variable "jenkins_admin_user" {
  default = "admin"
}
variable "jenkins_admin_password" {
  default = "Admin@123"
}
