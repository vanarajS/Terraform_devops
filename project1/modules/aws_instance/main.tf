resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key[${timestamp()}]"
  public_key = file(var.public_key_path)
  }

resource "aws_instance" "web1" {
  count = var.aws_instance_count
  instance_type = var.instance_type
  key_name = aws_key_pair.deployer.key_name
  subnet_id = var.subnet_id[count.index]
  ami = var.os_name
  user_data = file(var.app-testing)
  associate_public_ip_address = true 
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = var.ec2_name[count.index]
  }
}




output "instance_ids" {
  value = aws_instance.web1[*].id

}

output "instance_public_ip" {
  value = {
    for k, v in aws_instance.web1 : k.tags.Name => v.public_ip
  }

}
    







