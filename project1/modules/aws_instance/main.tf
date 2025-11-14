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
  associate_public_ip_address = true 
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

resource "aws_lb_target_group" "tg" {
  name     = "tf-test-tg-tcp"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_main_id

  target_group_health {
    dns_failover {
      minimum_healthy_targets_count      = "1"
      minimum_healthy_targets_percentage = "off"
    }

    unhealthy_state_routing {
      minimum_healthy_targets_count      = "1"
      minimum_healthy_targets_percentage = "off"
    }
  }
}

resource "aws_lb_target_group_attachment" "test" {
  for_each = {
    for k, v in aaws_instance.web1 : k => v
  }
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = each.value.id
  port             = 80
}


