output "jenkins_server_public_ip" {
  value = module.jenkins.public_ip
}

output "jenkins_ssm_parameters" {
  value = module.iam.ssm_parameters
}
