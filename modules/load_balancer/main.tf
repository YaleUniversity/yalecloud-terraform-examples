resource "aws_security_group" "alb_sg" {
  description = "${var.name} ALB SG"

  vpc_id = var.vpc_id
  name   = "${var.name}-alb-sg"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_alb" "alb" {
  name               = "${var.name}-alb"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
  load_balancer_type = "application"
  internal           = false

  enable_deletion_protection = false

  access_logs {
    bucket  = "yale-spinup-access-logs"
    prefix  = var.fqdn
    enabled = true
  }

  tags = var.tags
}

resource "aws_alb_listener" "listener_80" {
  load_balancer_arn = aws_alb.alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_target_group" "alb_tg" {
  name        = "${var.name}-tg"
  port        = "443"
  protocol    = "HTTPS"
  vpc_id      = var.vpc_id
  target_type = "instance"
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }

  tags = var.tags
}

resource "aws_alb_listener" "listener_443" {
  load_balancer_arn = aws_alb.alb.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.elbsecuritypolicy
  certificate_arn   = var.cert

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Host does not exist on this server."
      status_code  = "412"
    }
  }
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
  target_group_arn = aws_alb_target_group.alb_tg.id
  target_id        = var.target_id
  port             = "443"
}

resource "aws_lb_listener_rule" "route_ssl" {
  listener_arn = aws_alb_listener.listener_443.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_tg.arn
  }

  condition {
    host_header {
      values = ["${var.fqdn}"]
    }
  }
}
