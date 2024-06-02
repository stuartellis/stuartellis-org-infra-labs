# SPDX-FileCopyrightText: 2024-present Stuart Ellis <stuart@stuartellis.name>
#
# SPDX-License-Identifier: MIT

ec2_instance_config = {
  image_id                  = "ami-053a617c6207ecc7b" # Ubuntu 24.04 LTS
  instance_type             = "t3.micro"
  ebs_volume_size           = 24
  ebs_delete_on_termination = true
}

ec2_network_config = {
  subnet_id = "subnet-0172fa879168f2a33" # Availability Zone A
  vpc_id    = "vpc-001259a0593fd9029"
}

tf_exec_role_arn = "arn:aws:iam::444270794751:role/stuartellis-org-tf-exec-role"
