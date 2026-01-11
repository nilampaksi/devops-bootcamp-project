output "instance_ids" {
  value = {
    for k, v in aws_instance.vm :
    k => v.id
  }
}

output "ansible_private_key" {
  value     = tls_private_key.ansible.private_key_openssh
  sensitive = true
}

output "ansible_public_key" {
  value = tls_private_key.ansible.public_key_openssh
}
