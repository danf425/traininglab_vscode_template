// Setup AWS LB Target Group and Rules

resource "aws_lb_target_group_attachment" "workstation" {
  count            = var.workstation_count
  target_group_arn = "${aws_lb_target_group.workstation[count.index].arn}"
  target_id        = "${aws_instance.workstation[count.index].id}"
}

resource "aws_lb_target_group" "workstation" {
  count                = var.workstation_count
  name                 = "${var.tag_project}-WS-${count.index + 1}"
  vpc_id               = aws_vpc.habmgmt-vpc.id
  port                 = "8080"
  protocol             = "HTTP"

  depends_on = ["aws_lb.chef_automate"]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name          = format("${var.tag_contact}_WS_${count.index + 1}")
    X-Dept        = var.tag_dept
    X-Customer    = var.tag_customer
    X-Project     = var.tag_project
    X-Application = var.tag_application
    X-Contact     = var.tag_contact
    X-TTL         = var.tag_ttl
  }
}

resource "aws_lb_listener_rule" "workstation" {
  count               = var.workstation_count
  listener_arn        = "${aws_lb_listener.chef_automate.arn}"
  priority            = "${count.index + 100}"

  action {
    type              = "forward"
    target_group_arn  = "${aws_lb_target_group.workstation[count.index].arn}"
  }

  condition {
    host_header {
      values = ["${var.workstation_dns_prefix}-workstation-${count.index + 1}.chef-demo.com"]
    }
  }
}

resource "aws_route53_record" "workstation" {
  count   = var.workstation_count
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.workstation_dns_prefix}-workstation-${count.index + 1}"
  type    = "CNAME"
  ttl     = "30"
  records = [aws_lb.chef_automate.dns_name]
}

// Render template file for code-server.service with code_server_password variable

data "template_file" "code-server_service_config" {
  template = file("${path.module}/files/code-server.service.tpl")

  vars = {
    workstation_user_password = var.workstation_user_password
  }
}

data "template_file" "code-server_config" {
  template = file("${path.module}/files/code-server_config.yaml.tpl")

  vars = {
    workstation_user_password = var.workstation_user_password
  }
}

// Provision Workstations

resource "aws_instance" "workstation" {
  count                  = var.workstation_count
  ami                    = data.aws_ami.centos7.id
  key_name               = var.aws_key_pair_name
  subnet_id              = aws_subnet.habmgmt-subnet-a.id
  instance_type          = var.workstation_type
  ebs_optimized          = false
  vpc_security_group_ids = ["${aws_security_group.chef_automate.id}"]

  root_block_device {
    delete_on_termination = true
    volume_size           = var.workstation_volume_size
    volume_type           = "gp2"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = var.workstation_user
    private_key = file(var.aws_key_pair_file)
  }

  provisioner "file" {
    # source      = "${format("${path.module}/files/code-server.service")}"
    content     = data.template_file.code-server_service_config.rendered
    destination = "/tmp/code-server.service"
  }

    provisioner "file" {
    content     = data.template_file.code-server_config.rendered
    destination = "/tmp/config.yaml"
  }

  provisioner "file" {
    source      = format("${path.module}/files/code-server-settings.json")
    destination = "/tmp/code-server-settings.json"
  }

  provisioner "file" {
    source      = format("${path.module}/files/code-server-light-theme-settings.json")
    destination = "/tmp/code-server-light-theme-settings.json"
  }

  provisioner "file" {
    source = format("${path.module}/data-sources/provision-workstation.sh")

    # content     = "${data.template_file.provision-workstation.rendered}"
    destination = "/tmp/provision-workstation.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/provision-workstation.sh",
      "/tmp/provision-workstation.sh ${var.workstation_user_password}",
    ]
    # script = "${format("${path.module}/data-sources/provision-workstation.sh")}"
  }

  provisioner "file" {
    source = format("${path.module}/data-sources/setup-code-server.sh")
    destination = "/tmp/setup-code-server.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup-code-server.sh",
      "/tmp/setup-code-server.sh"
    ]
    # script = format("${path.module}/data-sources/setup-code-server.sh")
  }

  tags = {
    Name       = format("${var.tag_project}_workstation_${count.index + 1}")
    X-Dept        = var.tag_dept
    X-Customer    = var.tag_customer
    X-Project     = var.tag_project
    X-Application = var.tag_application
    X-Contact     = var.tag_contact
    X-TTL         = var.tag_ttl
  }

}
