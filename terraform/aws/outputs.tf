# output "training_lab_public_ip" {
#   value = aws_instance.training_lab.public_ip
# }

output "training_lab_server_public_r53_dns" {
  value = var.lab_hostname
}

# output "a2_admin" {
#   value = data.external.a2_secrets.result["a2_admin"]
# }

# output "a2_admin_password" {
#   value = data.external.a2_secrets.result["a2_password"]
# }

# output "a2_token" {
#   value = data.external.a2_secrets.result["a2_token"]
# }

# output "a2_url" {
#   value = data.external.a2_secrets.result["a2_url"]
# }

output "workstation_public_DNS" {
  value = "${aws_route53_record.workstation.*.fqdn}"
}

output "workstation_public_IPs" {
  value = "${aws_instance.workstation.*.public_ip}"
}

