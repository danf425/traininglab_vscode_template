resource "aws_lb" "training_lab" {
  load_balancer_type = "application"
  name               = "${var.tag_name}-lab-LB"
  internal           = "false"
  security_groups    = [aws_security_group.training_lab.id]
  subnets            = [aws_subnet.habmgmt-subnet-a.id, aws_subnet.habmgmt-subnet-b.id]
  tags = {
    Name          = "${var.tag_customer}-${var.tag_project}_${random_id.instance_id.hex}_${var.tag_application}_alb"
    X-Dept        = var.tag_dept
    X-Customer    = var.tag_customer
    X-Project     = var.tag_project
    X-Application = var.tag_application
    X-Contact     = var.tag_contact
    X-TTL         = var.tag_ttl
  }
}

resource "aws_lb_target_group" "training_lab" {
  name     = random_id.instance_id.hex
  vpc_id   = aws_vpc.habmgmt-vpc.id
  port     = "443"
  protocol = "HTTPS"

  depends_on = [aws_lb.training_lab]

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_acm_certificate" "training_lab" {
  domain      = var.lab_alb_acm_matcher
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_lb_listener" "training_lab" {
  load_balancer_arn = aws_lb.training_lab.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.training_lab.arn
  default_action {
    target_group_arn = aws_lb_target_group.training_lab.id
    type             = "forward"
  }
}

resource "aws_lb_listener" "training_lab_http" {
  load_balancer_arn = "${aws_lb.training_lab.arn}"
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

resource "aws_lb_listener_certificate" "training_lab" {
  listener_arn    = aws_lb_listener.training_lab.arn
  certificate_arn = data.aws_acm_certificate.training_lab.arn
}

# resource "aws_lb_target_group_attachment" "training_lab" {
#   target_group_arn = aws_lb_target_group.training_lab.arn
#   target_id        = aws_instance.training_lab.id
#   port             = 443
# }

data "aws_route53_zone" "selected" {
  name = var.lab_alb_r53_matcher
}

resource "aws_route53_record" "training_lab" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.lab_hostname
  type    = "CNAME"
  ttl     = "30"
  records = [aws_lb.training_lab.dns_name]
}

