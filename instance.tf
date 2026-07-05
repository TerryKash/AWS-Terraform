#creating ec2 instance
resource "aws_instance" "my-ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key-tf.key_name
  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "first-tf-instance"
  }
}

