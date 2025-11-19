resource "aws_lb_target_group" "tg" {
  name     = "tf-test-tg-tcp"
  port     = 80
  protocol = "HTTP"
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
  count = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.instance_ids[count.index]
  port             = 80
}


resource "aws_lb" "lb" {
  name               = "test-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = [for subnet in var.subnet_id : subnet]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

