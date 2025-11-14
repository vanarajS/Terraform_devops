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
  public_ip = true
  public_dns = true
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "web-${count.index}"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_main_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}   

