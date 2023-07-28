tf_exec_role_arn = "arn:aws:iam::333594256635:role/stuartellis-org-tf-exec-role"

ec2_instance_config = {
  image_id                  = "ami-059ddb696446729d4"
  instance_type             = "t3.micro"
  ebs_volume_size           = 24
  ebs_delete_on_termination = true
}

ec2_network_config = {
  subnet_id = "subnet-07019aefa85702bd1"
  vpc_id    = "vpc-050759a1c4452de7c"
}
