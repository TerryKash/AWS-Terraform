output "key" {
  value = aws_key_pair.key-tf.key_name
}

output "instance_plublic_IP" {
  value = aws_instance.my-ec2.public_ip
}

