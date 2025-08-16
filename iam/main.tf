resource "aws_iam_user" "jenkins_user" {
  name = "jenkins-admin"
}

resource "aws_iam_user_policy_attachment" "jenkins_admin_attach" {
  user       = aws_iam_user.jenkins_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "jenkins_access_key" {
  user = aws_iam_user.jenkins_user.name
}

resource "aws_ssm_parameter" "jenkins_akid" {
  name      = "/jenkins/credentials/access_key_id"
  type      = "SecureString"
  value     = aws_iam_access_key.jenkins_access_key.id
  overwrite = true
}

resource "aws_ssm_parameter" "jenkins_secret" {
  name      = "/jenkins/credentials/secret_access_key"
  type      = "SecureString"
  value     = aws_iam_access_key.jenkins_access_key.secret
  overwrite = true
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-jenkins-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "ec2_ssm_policy" {
  name        = "ec2-jenkins-ssm-policy"
  description = "Allow EC2 to read Jenkins credentials from SSM"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "kms:Decrypt"
        ],
        Resource = [
          aws_ssm_parameter.jenkins_akid.arn,
          aws_ssm_parameter.jenkins_secret.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ec2_ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.ec2_ssm_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-jenkins-ssm-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

output "ec2_instance_profile" {
  value = aws_iam_instance_profile.ec2_instance_profile.name
}

output "ssm_parameters" {
  value = [aws_ssm_parameter.jenkins_akid.name, aws_ssm_parameter.jenkins_secret.name]
}
